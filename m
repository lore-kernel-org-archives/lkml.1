Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbYJTVE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbYJTVE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYJTVEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:04:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:43070 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbYJTVEo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:04:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Fun1mzfpYmdsuCSdfFHAZKEQ84rQF2SryyVFoW8FRC5fGpQ7uAlVDrrLlMnf8/u4Pv
         KhTfe96XVQ2gHBoXDp9uDXesO1Lyp4EBqleYt8f0sxPK/6D64Ic6OBNCtoDZG7H/ttce
         UYdCjEdYLIdN1lYriC9SfKssQvYndZYYMHpck=
Message-ID: <a4e6962a0810201404t7fac7ec6n2e33b8f7917629eb@mail.gmail.com>
Date: Mon, 20 Oct 2008 16:04:43 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Jason Baron" <jbaron@redhat.com>
Subject: Re: [net/9p/9pnet.c] Compile error
Cc: "=?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?=" 
	<alejandro.riveira@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       v9fs-developer@lists.sourceforge.net, lucho@ionkov.net
In-Reply-To: <20081020204954.GC3161@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1224530845.22829.4.camel@varda> <20081020204954.GC3161@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 3:49 PM, Jason Baron <jbaron@redhat.com> wrote:
> On Mon, Oct 20, 2008 at 09:27:25PM +0200, Alejandro Riveira Fernández wrote:
>> Current Git
>>  v2.6.27-6030-g6da0b38
>>
>>  I get a build error
>>
>> Kernel: arch/x86/boot/bzImage is ready  (#17)
>>   Building modules, stage 2.
>>   MODPOST 571 modules
>> ERROR: "p9_debug_level" [net/9p/9pnet.ko] undefined!
>> make[3]: *** [__modpost] Error 1
>> make[2]: *** [modules] Error 2
>> make[1]: *** [sub-make] Error 2
>> make: *** [all] Error 2
>>

Sorry for the mess.  I'm pushing the following patch to my for-linus
tree which resolves the issue.

           -eric

9p: fix debug build error

Fixes build problem with 9p when building with debug disabled.
Also contains some fixes for warnings which pop up when
CONFIG_NET_9P_DEBUG is disabled.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index d2c60c7..b77c147 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -56,9 +56,9 @@ enum p9_debug_flags {
 	P9_DEBUG_PKT =		(1<<10),
 };

+#ifdef CONFIG_NET_9P_DEBUG
 extern unsigned int p9_debug_level;

-#ifdef CONFIG_NET_9P_DEBUG
 #define P9_DPRINTK(level, format, arg...) \
 do {  \
 	if ((p9_debug_level & level) == level) {\
diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 29be524..908e79f 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -53,6 +53,7 @@
 static int
 p9pdu_writef(struct p9_fcall *pdu, int optional, const char *fmt, ...);

+#ifdef CONFIG_NET_9P_DEBUG
 void
 p9pdu_dump(int way, struct p9_fcall *pdu)
 {
@@ -81,6 +82,12 @@ p9pdu_dump(int way, struct p9_fcall *pdu)
 	else
 		P9_DPRINTK(P9_DEBUG_PKT, "]]](%d) %s\n", datalen, buf);
 }
+#else
+void
+p9pdu_dump(int way, struct p9_fcall *pdu)
+{
+}
+#endif
 EXPORT_SYMBOL(p9pdu_dump);

 void p9stat_free(struct p9_wstat *stbuf)
@@ -542,8 +549,10 @@ int p9pdu_finalize(struct p9_fcall *pdu)
 	err = p9pdu_writef(pdu, 0, "d", size);
 	pdu->size = size;

+#ifdef CONFIG_NET_9P_DEBUG
 	if ((p9_debug_level & P9_DEBUG_PKT) == P9_DEBUG_PKT)
 		p9pdu_dump(0, pdu);
+#endif

 	P9_DPRINTK(P9_DEBUG_9P, ">>> size=%d type: %d tag: %d\n", pdu->size,
 							pdu->id, pdu->tag);
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index be65d82..1df0356 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -678,11 +678,9 @@ static int p9_fd_request(struct p9_client
*client, struct p9_req_t *req)

 static int p9_fd_cancel(struct p9_client *client, struct p9_req_t *req)
 {
-	struct p9_trans_fd *ts = client->trans;
-	struct p9_conn *m = ts->conn;
 	int ret = 1;

-	P9_DPRINTK(P9_DEBUG_TRANS, "mux %p req %p\n", m, req);
+	P9_DPRINTK(P9_DEBUG_TRANS, "client %p req %p\n", client, req);

 	spin_lock(&client->lock);
 	list_del(&req->req_list);
