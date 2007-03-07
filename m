Return-Path: <linux-kernel-owner+w=401wt.eu-S2992533AbXCGTxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992533AbXCGTxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992534AbXCGTxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:53:53 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53269 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992533AbXCGTxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:53:51 -0500
Date: Wed, 7 Mar 2007 11:50:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: "Randy Cushman" <rcushman_linux@earthlink.net>,
       "Takashi Iwai" <tiwai@suse.de>, "Jaroslav Kysela" <perex@suse.cz>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>
Subject: Re: mm snapshot broken-out-2007-03-05-02-22.tar.gz uploaded
Message-Id: <20070307115024.756c848f.akpm@linux-foundation.org>
In-Reply-To: <6bffcb0e0703071141j42309702w793e4a76b1b23bfa@mail.gmail.com>
References: <200703051024.l25AOIF3015951@shell0.pdx.osdl.net>
	<45EC2DEB.1050108@googlemail.com>
	<45EEA3C4.7000501@googlemail.com>
	<20070307104746.f08a2e84.akpm@linux-foundation.org>
	<6bffcb0e0703071141j42309702w793e4a76b1b23bfa@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 20:41:30 +0100 "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:

> > > 831466f4ad2b5fe23dff77edbe6a7c244435e973 is first bad commit
> > > commit 831466f4ad2b5fe23dff77edbe6a7c244435e973
> > > Author: Randy Cushman <rcushman_linux@earthlink.net>
> > > Date:   Tue Dec 19 18:42:16 2006 +0100
> > >
> > >     [ALSA] ac97 - fix microphone and line_in selection logic
> > >
> > >     This patch fixes the Microphone and LINE_IN select logic for
> > >     Analog Devices surround codecs with shared jacks.  The existing
> > >     code can never utilize the shared jacks for Microphone and LINE_IN
> > >     due to the reversed jack selection logic.  The patched code
> > >     correctly selects the shared jack for input if the 'Channel Mode'
> > >     selector does not specify that the jack is to be used for output.
> > >     Specifically, in '2ch' mode the Center/LFE jack is used for
> > >     microphone input and the Surround jack is used for LINE_IN,
> > >     in '4ch' mode the Center/LFE jack is used for microphone input
> > >     and the Surround jack is used for output, and in '6ch' mode
> > >     both jacks are used for output.
> > >
> > >     Signed-off-by: Randy Cushman <rcushman_linux@earthlink.net>
> > >     Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > >     Signed-off-by: Jaroslav Kysela <perex@suse.cz>
> > >
> >
> > Is 2.6.21-rc3 similarly broken?
> 
> Yes.
> 

OK.  Can you please confirm that applying the below fixes 2.6.21-rc3?

If so, I'll queue it up for application in a week or two if there is no
progress on this.




From: Andrew Morton <akpm@linux-foundation.org>

Revert 831466f4ad2b5fe23dff77edbe6a7c244435e973: "Michal Piotrowski"
<michal.k.k.piotrowski@gmail.com> reports that it broke his 3d surround.

Cc:"Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: Randy Cushman <rcushman_linux@earthlink.net>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/ac97/ac97_patch.c |   66 +++++++++++++---------------------
 1 file changed, 26 insertions(+), 40 deletions(-)

diff -puN sound/pci/ac97/ac97_patch.c~revert-ac97-fix-microphone-and-line_in-selection-logic sound/pci/ac97/ac97_patch.c
--- a/sound/pci/ac97/ac97_patch.c~revert-ac97-fix-microphone-and-line_in-selection-logic
+++ a/sound/pci/ac97/ac97_patch.c
@@ -178,28 +178,14 @@ static inline int is_clfe_on(struct snd_
 	return ac97->channel_mode >= 2;
 }
 
-/* system has shared jacks with surround out enabled */
-static inline int is_shared_surrout(struct snd_ac97 *ac97)
-{
-	return !ac97->indep_surround && is_surround_on(ac97);
-}
-
-/* system has shared jacks with center/lfe out enabled */
-static inline int is_shared_clfeout(struct snd_ac97 *ac97)
-{
-	return !ac97->indep_surround && is_clfe_on(ac97);
-}
-
-/* system has shared jacks with line in enabled */
 static inline int is_shared_linein(struct snd_ac97 *ac97)
 {
-	return !ac97->indep_surround && !is_surround_on(ac97);
+	return ! ac97->indep_surround && is_surround_on(ac97);
 }
 
-/* system has shared jacks with mic in enabled */
 static inline int is_shared_micin(struct snd_ac97 *ac97)
 {
-	return !ac97->indep_surround && !is_clfe_on(ac97);
+	return ! ac97->indep_surround && is_clfe_on(ac97);
 }
 
 
@@ -2473,12 +2459,12 @@ static void alc650_update_jacks(struct s
 {
 	int shared;
 	
-	/* shared Line-In / Surround Out */
-	shared = is_shared_surrout(ac97);
+	/* shared Line-In */
+	shared = is_shared_linein(ac97);
 	snd_ac97_update_bits(ac97, AC97_ALC650_MULTICH, 1 << 9,
 			     shared ? (1 << 9) : 0);
-	/* update shared Mic In / Center/LFE Out */
-	shared = is_shared_clfeout(ac97);
+	/* update shared Mic */
+	shared = is_shared_micin(ac97);
 	/* disable/enable vref */
 	snd_ac97_update_bits(ac97, AC97_ALC650_CLOCK, 1 << 12,
 			     shared ? (1 << 12) : 0);
@@ -2608,12 +2594,12 @@ static void alc655_update_jacks(struct s
 {
 	int shared;
 	
-	/* shared Line-In / Surround Out */
-	shared = is_shared_surrout(ac97);
+	/* shared Line-In */
+	shared = is_shared_linein(ac97);
 	ac97_update_bits_page(ac97, AC97_ALC650_MULTICH, 1 << 9,
 			      shared ? (1 << 9) : 0, 0);
-	/* update shared Mic In / Center/LFE Out */
-	shared = is_shared_clfeout(ac97);
+	/* update shared mic */
+	shared = is_shared_micin(ac97);
 	/* misc control; vrefout disable */
 	snd_ac97_update_bits(ac97, AC97_ALC650_CLOCK, 1 << 12,
 			     shared ? (1 << 12) : 0);
@@ -2757,16 +2743,16 @@ static void alc850_update_jacks(struct s
 {
 	int shared;
 	
-	/* shared Line-In / Surround Out */
-	shared = is_shared_surrout(ac97);
+	/* shared Line-In */
+	shared = is_shared_linein(ac97);
 	/* SURR 1kOhm (bit4), Amp (bit5) */
 	snd_ac97_update_bits(ac97, AC97_ALC850_MISC1, (1<<4)|(1<<5),
 			     shared ? (1<<5) : (1<<4));
 	/* LINE-IN = 0, SURROUND = 2 */
 	snd_ac97_update_bits(ac97, AC97_ALC850_JACK_SELECT, 7 << 12,
 			     shared ? (2<<12) : (0<<12));
-	/* update shared Mic In / Center/LFE Out */
-	shared = is_shared_clfeout(ac97);
+	/* update shared mic */
+	shared = is_shared_micin(ac97);
 	/* Vref disable (bit12), 1kOhm (bit13) */
 	snd_ac97_update_bits(ac97, AC97_ALC850_MISC1, (1<<12)|(1<<13),
 			     shared ? (1<<12) : (1<<13));
@@ -2839,9 +2825,9 @@ static int patch_alc850(struct snd_ac97 
  */
 static void cm9738_update_jacks(struct snd_ac97 *ac97)
 {
-	/* shared Line-In / Surround Out */
+	/* shared Line-In */
 	snd_ac97_update_bits(ac97, AC97_CM9738_VENDOR_CTRL, 1 << 10,
-			     is_shared_surrout(ac97) ? (1 << 10) : 0);
+			     is_shared_linein(ac97) ? (1 << 10) : 0);
 }
 
 static const struct snd_kcontrol_new snd_ac97_cm9738_controls[] = {
@@ -2923,12 +2909,12 @@ static const struct snd_kcontrol_new snd
 
 static void cm9739_update_jacks(struct snd_ac97 *ac97)
 {
-	/* shared Line-In / Surround Out */
+	/* shared Line-In */
 	snd_ac97_update_bits(ac97, AC97_CM9739_MULTI_CHAN, 1 << 10,
-			     is_shared_surrout(ac97) ? (1 << 10) : 0);
-	/* shared Mic In / Center/LFE Out **/
+			     is_shared_linein(ac97) ? (1 << 10) : 0);
+	/* shared Mic */
 	snd_ac97_update_bits(ac97, AC97_CM9739_MULTI_CHAN, 0x3000,
-			     is_shared_clfeout(ac97) ? 0x1000 : 0x2000);
+			     is_shared_micin(ac97) ? 0x1000 : 0x2000);
 }
 
 static const struct snd_kcontrol_new snd_ac97_cm9739_controls[] = {
@@ -3040,8 +3026,8 @@ static void cm9761_update_jacks(struct s
 
 	val |= surr_on[ac97->spec.dev_flags][is_surround_on(ac97)];
 	val |= clfe_on[ac97->spec.dev_flags][is_clfe_on(ac97)];
-	val |= surr_shared[ac97->spec.dev_flags][is_shared_surrout(ac97)];
-	val |= clfe_shared[ac97->spec.dev_flags][is_shared_clfeout(ac97)];
+	val |= surr_shared[ac97->spec.dev_flags][is_shared_linein(ac97)];
+	val |= clfe_shared[ac97->spec.dev_flags][is_shared_micin(ac97)];
 
 	snd_ac97_update_bits(ac97, AC97_CM9761_MULTI_CHAN, 0x3c88, val);
 }
@@ -3289,12 +3275,12 @@ static int patch_vt1617a(struct snd_ac97
  */
 static void it2646_update_jacks(struct snd_ac97 *ac97)
 {
-	/* shared Line-In / Surround Out */
+	/* shared Line-In */
 	snd_ac97_update_bits(ac97, 0x76, 1 << 9,
-			     is_shared_surrout(ac97) ? (1<<9) : 0);
-	/* shared Mic / Center/LFE Out */
+			     is_shared_linein(ac97) ? (1<<9) : 0);
+	/* shared Mic */
 	snd_ac97_update_bits(ac97, 0x76, 1 << 10,
-			     is_shared_clfeout(ac97) ? (1<<10) : 0);
+			     is_shared_micin(ac97) ? (1<<10) : 0);
 }
 
 static const struct snd_kcontrol_new snd_ac97_controls_it2646[] = {
_

