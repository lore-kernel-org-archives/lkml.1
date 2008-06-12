Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbYFLVuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbYFLVuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYFLVuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:50:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:36044 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbYFLVue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:50:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FN+yEfPpdpr1TgjuCjIFkoSYuaY+r/rKhEJ1zKWMx0uXM1fQgTPgBW9VPWOo2/8pXM
         e7ceXRIVQ+ye27+WgW50CevDvgjwHFvalyRXuIOoIc+x9R9yHr4kMj4aV8YRb99g5faQ
         OMwOriEsOraaY/xdE1SZJmuOJrj06WNI+tJHQ=
Message-ID: <6278d2220806121450h39280637udbe06ffb92fbb0d1@mail.gmail.com>
Date: Thu, 12 Jun 2008 22:50:32 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: ALC883 recording troubles...
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
In-Reply-To: <s5hiqwf0vyr.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <s5habhtesoq.wl%tiwai@suse.de>
	 <6278d2220806111200g4f802885wfc5f0fd6c0405efb@mail.gmail.com>
	 <s5hiqwf0vyr.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 11:49 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 11 Jun 2008 20:00:17 +0100,
> Daniel J Blueman wrote:
>>
>> On Tue, Jun 10, 2008 at 6:59 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Mon, 9 Jun 2008 20:59:00 +0100,
>> > Daniel J Blueman wrote:
>> >>
>> >> Hi Takashi-san,
>> >>
>> >> I'm experiencing DC offset with the microphone on 2.6.24 (Ubuntu 8.04
>> >> LTS x86-64). I can see on Audacity that the DC offset that varies with
>> >> the recording capture level.
>> >
>> > Could you elaborate?  The mic bias level could be changed via the pin
>> > control value.  Usually, it's set as VREF 80%.
>>
>> When the recording->capture level is set to 0, the mic has no DC
>> offset as expected. Maxing the recording->capture level, the mic input
>> is saturated, in between, we see a linear connection.
>>
>> >> Plus, the mixer playback->mic-boost
>> >> muting enables/disables mic-boost in recording.
>> >
>> > This is a known bug in alsa-lib mixer abstraction.  No kernel issue.
>>
>> >> It feels like the ALC883 pins aren't configured quite right. The mobo
>> >> is an Asus P5E-VM with current BIOS [1]
>> >>
>> >> What's the routine to debug this? Would it help to install windows,
>> >> dump the register space and compare?
>> >
>> > You can find *.INI file that contains the default pin configuration
>> > in Windows.  This might be useful in the case BIOS is broken but
>> > Windows does a black magic.
>>
>> That'll be these defaults stashed in the INF file [2]. Let me know if
>> it's not what you expected and I'll publish the complete INF file.
>>
>> > Anyway, please run alsa-info.sh with --no-upload option and show the
>> > generated file here.  It contains the codec information and mixer
>> > setup.
>> >        http://hg.alsa-project.org/alsa/raw-file/tip/alsa-info.sh
>>
>> See [3].
>>
>> > Also, you can adjust the pin setting on the fly via hda-verb utility
>> > below:
>> >        http://ftp.suse.com/pub/people/tiwai/misc/hda-verb-0.2.tar.bz2
>> >
>> > Don't forget to build snd-hda-intel module with
>> > CONFIG_SND_HDA_HWDEP=y to use this command.
>>
>> I'll give this a shot if I get time.
>
> You can try to adjust VREF value of mic pins.
> For example, the node 0x18 and 0x19 correspond to the rear and front
> mics, respectively.  Then run the following as root:
>
>        # ./hda-verb /dev/snd/hwC0D0 0x18 SET_PIN_WID 0x21
>
> which will change the widget 0x18 (rear mic) to input-VREF 50%
> (0x21).  The original value is input-VREF 80% (0x24).

Yes, I had tried this and it does not help, perhaps only changing the
magnitude of the sampled mic input.

Another smoking gun, is when changing certain mixer settings (both on
gnome-mixer and alsamixer), eg playback->front mic amplitude, moving
the slider up and down, the L/R linking seems to be almost randomly
unlinked and the other L/R channel jumps to a different value. When
re-linking the L/R channels, often, it'll unlink again and change both
value after reading back the change; mute can be erratic too.
Confirmed with 2.6.26-r5.

Is there a good way to debug this also?

> Takashi
-- 
Daniel J Blueman
