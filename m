Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbZD1WWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbZD1WWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 18:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZD1WWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 18:22:05 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:41718 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbZD1WWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 18:22:03 -0400
Date: Tue, 28 Apr 2009 18:21:55 -0400
From: Andres Salomon <dilinger@queued.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Kailang Yang <kailang@realtek.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: realtek ALC272 support
Message-ID: <20090428182155.3f6eae50@dev.queued.net>
In-Reply-To: <20090428154108.6ed3136d@dev.queued.net>
References: <20090424152415.10fcebff@dev.queued.net>
	<s5hljpp3z2w.wl%tiwai@suse.de>
	<20090425101753.1983e6ae@dev.queued.net>
	<s5hocujwuhb.wl%tiwai@suse.de>
	<20090427100151.01a46965@dev.queued.net>
	<s5hprey3yc5.wl%tiwai@suse.de>
	<20090427120230.74d70f88@dev.queued.net>
	<s5hbpqi3wqy.wl%tiwai@suse.de>
	<20090428154108.6ed3136d@dev.queued.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 15:41:08 -0400
Andres Salomon <dilinger@queued.net> wrote:

> On Mon, 27 Apr 2009 18:08:21 +0200
> Takashi Iwai <tiwai@suse.de> wrote:
> 
[...]
> > > > > > > > At Fri, 24 Apr 2009 15:24:15 -0400,
> > > > > > > > Andres Salomon wrote:
> > > > > > > > > 
> > > > > > > > > Hi Kailang,
> > > > > > > > > 
> > > > > > > > > I noticed that your name was on the ALC272 support
> > > > > > > > > patch for ALSA intel-hda.  This patch basically sets
> > > > > > > > > ALC272 to use (mostly) the same code as ALC662.  I
> > > > > > > > > have two machines that have ALC272, and both of them
> > > > > > > > > need verb tables in order to function.  I'm wondering
> > > > > > > > > if ALC662 should really be used..
> > > > > > > > > 
> > > > > > > > > Here's one -
> > > > > > > > > 
> > > > > > > > > http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-hardy-lum.git;a=commitdiff;h=7662834bb9a78d244c6d7ee43358c14c94d249c9
> > > > > > > > > 
> > > > > > > > > This isn't the final version of the patch (there are
> > > > > > > > > further commits I made in order to support headphone
> > > > > > > > > mic stuff), but it gives you an idea of the codec
> > > > > > > > > values. The other is:
> > > > > > > > > 
> > > > > > > > > http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-hardy-lum.git;a=commitdiff;h=72ff85641a30dc7ac502e2ea01bf14a04efb4cf1
> > > > > > > > > 
> > > > > > > > > All of these leave me wonder if there's a specific
> > > > > > > > > patch_alc272 function that could be written to rid
> > > > > > > > > ourselves of these specific quirks.  Are there
> > > > > > > > > machines with ALC272 that are functional with the
> > > > > > > > > current ALSA code?
> > > > > > > > 
[...]
> > 
> > Could you try sound-unstable tree a bit later again?
> > I found a bug in my patch, and fixed and updated GIT tree now.
> > At least, the headphone plugging should work now.
> > 
> > The mic auto-detection still doesn't work with model=auto, though.
> > So, I'm going to take your patch anyway later.  But I just wanted
> > to be sure that the current tree could work somehow better...
> > 
> 
> Hi,
> 
> I just updated and tried the current tree; still no sound/headphone
> output.  :(


Ok, I believe I've made some progress on this.  The problem appears to
be related to the autoconfig handling of the line out nids.  The
current code ends up with something like the following:

ALSA sound/pci/hda/hda_codec.c:3833: autoconfig: line_outs=1
(0x17/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3837:    speaker_outs=0
(0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3841:    hp_outs=1 (0x21/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3842:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:3853: inputs: mic=0x18, fmic=0x19,
line=0x0, fline=0x0, cd=0x0, aux=0x0

However, NID 0x17 is actually a speaker_out.  The code that checks for
line_outs in snd_hda_parse_pin_def_config() unsets the speaker_out and
uses that NID for a line_out.  For whatever reason, this breaks things
(no sound output, no headphone out).


According to the ALC272 data sheet (the block diagram on page 5),
there are actually 2 line_out NIDs; 0x14 and 0x15.  The default pin
configs for these two NIDs (0x411111f0 for both) have the Port
Connectivity field set to AC_JACK_PORT_NONE, so the auto-config skips
those NIDs.

If I provide an override to a) set Port Connectivity to
AC_JACK_PORT_COMPLEX, and b) set Default Device to AC_JACK_LINE_OUT
(from AC_JACK_SPEAKER), I get usable audio (speakers work,
headphone works, headphone plugging mutes the speaker properly, and
even the mic works).  The patch which I've used is below.

Clearly, this isn't a very nice solution, so the question is:
is there a way to provide an override/quirk for pincfgs (I see one for
HWDEP, but that's configuration-specific) within the current hda_codec
framework for this specific codec/laptop?  Alternatively, I can try and
figure out what's wrong with the code in the case where
line_out_pins[0] is set to the speaker_out_pins[0] (ie, NID 0x17 in
this case).  

I can check the other ALC272 machine tomorrow (the DELL_ZM1) to see if
the line_out hack enables it to work without the verb table.




diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index b91f6ed..5aa7a0c 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -3644,6 +3644,15 @@ int snd_hda_parse_pin_def_config(struct hda_codec *codec,
 			continue;
 
 		def_conf = snd_hda_codec_get_pincfg(codec, nid);
+		snd_printd("nid %x: pincfg def_conf=%x\n", nid, def_conf);
+		if (codec->vendor_id == 0x10ec0272 &&
+				(nid == 0x14 || nid == 0x15)) {
+			def_conf &= ~(0x3 << AC_DEFCFG_PORT_CONN_SHIFT);
+			def_conf &= ~(0xf << AC_DEFCFG_DEVICE_SHIFT);
+			snd_printd("nid %x: overriding def_conf, now %x\n", nid,
+					def_conf);
+		}
+
 		if (get_defcfg_connect(def_conf) == AC_JACK_PORT_NONE)
 			continue;
 		loc = get_defcfg_location(def_conf);
