Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab0BVCNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 21:13:21 -0500
Received: from mail-qy0-f175.google.com ([209.85.221.175]:59431 "EHLO
	mail-qy0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab0BVCNT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 21:13:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pHqtsUqypKeMRNMDzSI4szm9G/dGBr7QQqS4NI7vnNV52l+GPNaNuQ2ZRHtdlmhaun
         YQuPILUX7N8cPzAWk23ckKtCm4NwJl01Z60eizZFInkSVIpPNExbNB367I5PhxkzdGy9
         1vh/91RrwHT/FjLWxPSlvP2LlkSWBLYup8uHE=
MIME-Version: 1.0
In-Reply-To: <wj3ZQZlk_KB.A.M6B.QsagLB@chimera>
References: <4u4d-2M3yXH.A.XW.XqagLB@chimera>
	 <wj3ZQZlk_KB.A.M6B.QsagLB@chimera>
Date: Mon, 22 Feb 2010 10:13:18 +0800
Message-ID: <2375c9f91002211813m8f637c1g73c4314eab96f81e@mail.gmail.com>
Subject: Re: [Bug #14943] nfs regression?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Nikola Ciprich <extmaillist@linuxbox.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 5:42 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14943
> Subject         : nfs regression?
> Submitter       : Nikola Ciprich <extmaillist@linuxbox.cz>
> Date            : 2009-12-28 12:10 (56 days old)
> References      : http://marc.info/?l=linux-kernel&m=126200276223524&w=4
>

This seems that we missed checking XPT_DEAD too.

Nikola, does adding !test_bit(XPT_DEAD, &xprt->xpt_flags) in the same
place as commit b292cf9ce70d221c3f04f help?

Something like:

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 7d1f9e9..7b66c7f 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -700,7 +700,8 @@ int svc_recv(struct svc_rqst *rqstp, long timeout)

        len = 0;
        if (test_bit(XPT_LISTENER, &xprt->xpt_flags) &&
-           !test_bit(XPT_CLOSE, &xprt->xpt_flags)) {
+           !test_bit(XPT_CLOSE, &xprt->xpt_flags) &&
+           !test_bit(XPT_DEAD, &xprt->xpt_flags)) {
                struct svc_xprt *newxpt;
                newxpt = xprt->xpt_ops->xpo_accept(xprt);
                if (newxpt) {
