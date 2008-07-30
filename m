Return-Path: <linux-kernel-owner+w=401wt.eu-S1761995AbYG3OH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761995AbYG3OH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYG3OHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:07:47 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53527 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbYG3OHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:07:47 -0400
Date: Wed, 30 Jul 2008 17:06:55 +0300
From: Adrian Bunk <adrian.bunk@movial.fi>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Marco Berizzi <pupilla@hotmail.com>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Grant Coady <grant_lkml@dodo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFT: 2.6 patch] fix text console corruptions
Message-ID: <20080730140655.GC19966@cs181140183.pp.htv.fi>
References: <BAY103-DAV4F0ECBCAFB86B24C87D3EB2820@phx.gbl> <200807291815.13907.alistair@devzero.co.uk> <BAY103-W38794846AA924235B38E47B2820@phx.gbl> <488FAFE3.4040001@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <488FAFE3.4040001@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 05:03:47PM -0700, Tim Bird wrote:
> Marco Berizzi wrote:
> > alistair@devzero.co.uk wrote:
> > 
> >> You don't actually say whether you had CONFIG_CONSOLE_TRANSLATIONS=y or not?
> > 
> > yes console_translation is set to yes. It cannot be changed if embedded is not
> > set.
> 
> If console_translation is set to yes, the behavior should be unchanged from
> 2.6.26.
>...

Your commit contains a change that breaks due to | having a higher 
precedence than ?: in C.

Untested patch below, can anyone who ran into this bug confirm that
it fixes it?

> Thanks,
>  -- Tim

cu
Adrian


<--  snip  -->


This patch fixes text console corruptions caused by
commit a29ccf6f823a84d89e1c7aaaf221cf7282022024
(Make console charset translation optional).

Reported-by: Marco Berizzi <pupilla@hotmail.com>
Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

---
cab22ec7afdc4c08a10ef9730b0ae2848754532c 
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 14c0e91..8c8119f 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -74,7 +74,7 @@ void con_protect_unimap(struct vc_data *vc, int rdonly);
 int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc);
 
 #define vc_translate(vc, c) ((vc)->vc_translate[(c) |			\
-					(vc)->vc_toggle_meta ? 0x80 : 0])
+					((vc)->vc_toggle_meta ? 0x80 : 0)])
 #else
 #define con_set_trans_old(arg) (0)
 #define con_get_trans_old(arg) (-EINVAL)

