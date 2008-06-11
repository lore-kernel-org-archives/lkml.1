Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbYFKNsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbYFKNsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 09:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYFKNsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 09:48:39 -0400
Received: from styx.suse.cz ([82.119.242.94]:49627 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751359AbYFKNsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 09:48:39 -0400
Date: Wed, 11 Jun 2008 15:48:37 +0200
From: Jiri Bohac <jbohac@suse.cz>
To: samuel.thibault@ens-lyon.org, Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] console keyboard mapping broken by 04c71976
Message-ID: <20080611134837.GA11462@midget.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the Czech (and I believe many other) console keyboard maps are
broken since 04c71976. 

To make old (non-unicode - the majority distributed with the kbd
package) keymaps work, the keyboard mapping in the kernel uses a
trick. It uses the translation tables loaded with the console
font to translate the 8-bit values to unicode values.

So with the currently available keymaps when using unicode in
the console you end up with:

- kbd->kbdmode set to VC_UNICODE, to send UTF-8 sequences to the
  terminal
- most letters, icluding non-latin1, defined as type=KT_LETTER in the
  keymap, with an 8-bit value, which only has its correct meaning
  when translated using conv_8bit_to_uni().

04c71976 changes k_self() to:
static void k_self(struct vc_data *vc, unsigned char value, char up_flag)
{
	unsigned int uni;
	if (kbd->kbdmode == VC_UNICODE)
		uni = value;
	else
		uni = conv_8bit_to_uni(value);
	k_unicode(vc, uni, up_flag);
}

It wrongly assumes, that when the keyboard is in the VC_UNICODE
mode, value is already the correct unicode value. This is only
true for latin1.

I think we need to always convert the value with
conv_8bit_to_uni(), as we did before 04c71976.

The following patch fixes the problem for me: 

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index 7f7e798..16492b7 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -678,10 +678,7 @@ static void k_deadunicode(struct vc_data *vc, unsigned int value, char up_flag)
 static void k_self(struct vc_data *vc, unsigned char value, char up_flag)
 {
 	unsigned int uni;
-	if (kbd->kbdmode == VC_UNICODE)
-		uni = value;
-	else
-		uni = conv_8bit_to_uni(value);
+	uni = conv_8bit_to_uni(value);
 	k_unicode(vc, uni, up_flag);
 }

As far as I can see, it will affect latin1 users that now get
their keymaps working even without loading the "trivial" console
map (so the conversion will not do anything) but I think they
needed to do that before 04c71976, so they probably still do
without even knowing, right?

Samuel, any comments?

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

