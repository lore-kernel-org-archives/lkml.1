Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbYG3ULp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbYG3ULp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYG3ULh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:11:37 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:15625 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbYG3ULg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Yz7E/KlSLyp9l0gXiNksBsd4Ro+hzw5Nck93rp2QXMM3p/wim3wfm6qANxfBqTaGFZ
         1Q9BnDtywlMjHJoXYuApZTDgtmHf7p6m76+4cEqGAN7YR798QulV1woddZY2M04NwBsn
         KNO50G+9Qmlnz3IRRZcqIJAstH0RIgKdpfGPE=
Message-ID: <f19298770807301311j1c742979je87ec7edfbf85173@mail.gmail.com>
Date: Thu, 31 Jul 2008 00:11:34 +0400
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: commit a352def21a642133758b868c71bee12ab34ad5c5 broke pptp.
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <f19298770807280350r79b2811er79061bb4fa363369@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f19298770807231111p2aaa2a3eyc4bf0c084c626c9b@mail.gmail.com>
	 <f19298770807280350r79b2811er79061bb4fa363369@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 2:50 PM, Alexey Zaytsev
<alexey.zaytsev@gmail.com> wrote:
> On Wed, Jul 23, 2008 at 10:11 PM, Alexey Zaytsev
> <alexey.zaytsev@gmail.com> wrote:
>> Hello.
>>
>>
>> Pptp breaks for me on the current git (c010b2f76):
>>
>> root@nx:~# pppd call semunlim defaultroute nodetach debug
>> Couldn't set tty to PPP discipline: Invalid argument
>> Waiting for 1 child processes...
>>  script pptp 172.18.2.2 --nolaunchpppd, pid 4359
>> root@nx:~#
>>
>> It bisects to:
>> a352def21a642133758b868c71bee12ab34ad5c5 tty: Ldisc revamp
>>
>> Revetring this commit, along with
>> 7a4d29f426f17479395980ded8fa5e3bdd6d94e4
>> and 01e1abb2c27e43339b8829a2e3b1c6f53806b77a fixes the problem.
>>
>
> Still there (c9272c4f). Could you maybe revert this for the -rc1? If not the
> problem, this would probably be the first -rc1 ever that actually
> works for me. ;)
>

Hai, I fixd ur kernel.
The problem was with the screwd up ldisc modules autoloading.
Pls apply the patch. Kthx bai.


    Fix ldisc module autoloading.

    Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 241cbde..a858893 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -164,14 +164,16 @@ static int tty_ldisc_try_get(int disc, struct
tty_ldisc *ld)

 static int tty_ldisc_get(int disc, struct tty_ldisc *ld)
 {
-       int err;
+       int err = 0;

        if (disc < N_TTY || disc >= NR_LDISCS)
                return -EINVAL;
-       err = tty_ldisc_try_get(disc, ld);
-       if (err == -EAGAIN) {
-               request_module("tty-ldisc-%d", disc);
-               err = tty_ldisc_try_get(disc, ld);
+       tty_ldisc_try_get(disc, ld);
+       if (!ld->ops) {
+               do {
+                       request_module("tty-ldisc-%d", disc);
+                       err = tty_ldisc_try_get(disc, ld);
+               } while (err == -EAGAIN);
        }
        return err;
 }
