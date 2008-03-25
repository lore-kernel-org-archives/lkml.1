Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbYCYA2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbYCYA2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 20:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYCYA2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 20:28:10 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:37512 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbYCYA2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 20:28:09 -0400
Message-ID: <47E8475E.4080705@keyaccess.nl>
Date: Tue, 25 Mar 2008 01:29:18 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Michael Cree <mcree@orcon.net.nz>
CC: Bob Tracy <rct@frus.com>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080318032427.298BCDBA2@gherkin.frus.com> <546A47FE-F98E-49E2-A250-41F65C2D482B@orcon.net.nz> <47E6338E.8030001@orcon.net.nz> <47E7EFDF.2070706@keyaccess.nl> <47E83F94.8010409@orcon.net.nz>
In-Reply-To: <47E83F94.8010409@orcon.net.nz>
Content-Type: multipart/mixed;
 boundary="------------040105040203000403010201"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040105040203000403010201
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 25-03-08 00:56, Michael Cree wrote:

> I have applied the patch to the PWS600au.  Sound now works.  I can play 
> 8bit and 16bit sound files through the es1887 and the C-Media CM8738. 
> They are both working fine.

Thanks much for the quick reply. That's good to hear. As indicated, Bob 
seemed to be experiencing something else but this is pretty fundamental so 
I'll not try to comment on his case any further until he's had a chance to 
test this as well.

Takashi -- over to you for Michael's issue? His PWS600AU (MIATA) system 
soils itself badly when using SNDRV_PCM_INFO_MMAP. His XP1000 works fine and 
I haven't the faintest clue if switching on CONFIG_ALPHA_MIATA is the proper 
switch, nor if outright disabling mmap is the correct approach. The patch 
that works for him is attached again for reference.

The way this does the disabling also implies disabling SNDRV_PCM_INFO_IOMEM 
by the way...

> I managed to get a 32bit sound file to play through the M-Audio
> Revolution too. (Though another 32bit sound file just produces silence
> through the M-Audio Rev. Haven't been able to establish why - the file
> looks fine to me.)  Repeated playing of files doesn't cause any problems.
> 
> I can't get sox's play to work (reports no mmap support, which is, of 
> course, quite true).  I don't know how to tell sox to use the equivalent
> of alsa's hw device.  So I can't do the test on short files that Bob was
> performing.

$ sox foo.wav -t alsa hw

should do it. Here's a file Bob passed me as a problematic one. 8-bit, 
11025, mono:

http://members.home.nl/rene.herman/asskickd.wav

> At this stage I've run out of time to test the M-Audio Rev in the XP1000 
> and see if the MMAP disable patch help there.

Given that it fixes es18xx and cmipci on the PWS600au and that those worked 
without trouble on the XP1000, you'd _expect_ not, but the OOPs you posted 
before seemed to indicate that it stands a fair chance afer all.

Rene.

--------------040105040203000403010201
Content-Type: text/plain;
 name="miata_no_mmap.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="miata_no_mmap.diff"

diff --git a/include/sound/asound.h b/include/sound/asound.h
index 3eaf155..e3b9c2d 100644
--- a/include/sound/asound.h
+++ b/include/sound/asound.h
@@ -241,8 +241,14 @@ typedef int __bitwise snd_pcm_subformat_t;
 #define	SNDRV_PCM_SUBFORMAT_STD		((__force snd_pcm_subformat_t) 0)
 #define	SNDRV_PCM_SUBFORMAT_LAST	SNDRV_PCM_SUBFORMAT_STD
 
+#ifdef CONFIG_ALPHA_MIATA
+#define SNDRV_PCM_INFO_MMAP		0		/* the useful comment goes here */
+#define SNDRV_PCM_INFO_MMAP_VALID	0
+#else
 #define SNDRV_PCM_INFO_MMAP		0x00000001	/* hardware supports mmap */
 #define SNDRV_PCM_INFO_MMAP_VALID	0x00000002	/* period data are valid during transfer */
+#endif
+
 #define SNDRV_PCM_INFO_DOUBLE		0x00000004	/* Double buffering needed for PCM start/stop */
 #define SNDRV_PCM_INFO_BATCH		0x00000010	/* double buffering */
 #define SNDRV_PCM_INFO_INTERLEAVED	0x00000100	/* channels are interleaved */

--------------040105040203000403010201--
