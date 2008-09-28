Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbYI1PQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbYI1PQF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYI1PPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:15:54 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:2672 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbYI1PPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ac7N0XSYvtwq7k6ctLwXrt0l5dJvzb55HBAoyemUublX46DIFbLCB4RRr+9qYEo8hv
         Kwqk5UeM/lG4HXlOKwr2VekK4Mv4CMuSCEVLKggJ6G5JZxWseR4paF498Qge/7/p0aqK
         CFa9usWs2Wd+hgRhJ2CiKzBeRRSBK2krQ+cOo=
Message-ID: <c384c5ea0809280815l63fab13fqf97a619598f0dd71@mail.gmail.com>
Date: Sun, 28 Sep 2008 17:15:52 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       jens.axboe@oracle.com
Subject: scatterlist.c: bug in sg_next()?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was code-inspecting 2.6.27-r7 through git web, when I came across this:

In sg_next(), after following a chain_ptr, a few more checks should be
performed.
The rare case exists that the first entry in the chained list is a
last marker, in case NULL must be returned.

Can someone confirm and cook a patch?

struct scatterlist *sg_next(struct scatterlist *sg)
{
  if (sg_is_last(sg))
    return NULL;
  sg++;
  if (unlikely(sg_is_chain(sg))) {
     sg = sg_chain_ptr(sg);
+#ifdef CONFIG_DEBUG_SG
+ BUG_ON(sg->sg_magic != SG_MAGIC);
+#endif
+   if (sg_is_last(sg))
+     return NULL;
  }
  return sg;
}

Signed-off-by: Leon Woestenberg <leon@sidebranch.com>

Regards,
-- 
Leon
