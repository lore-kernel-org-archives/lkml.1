Return-Path: <linux-kernel-owner+w=401wt.eu-S1764209AbYF1AFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764209AbYF1AFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 20:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759492AbYF1AF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 20:05:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:18873 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378AbYF1AF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 20:05:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WQW5qSKQw7z46xUC01dG/dhEAP4EhEcBpX2Gdvgasp3aL5qLCP8x3T5k7LQGtLov/U
         ZExgmLUEJ4jsae0a934Ez2JrXr8EE7ix+oyMfnDbBgkm3bC909/SowoN41yu0CJBvOOR
         ik9O/gOLleWfhYwzGUOw9U1KyRkNw7a25b8XU=
Message-ID: <6278d2220806271705v5bd5fec3l86c3560283063092@mail.gmail.com>
Date: Sat, 28 Jun 2008 01:05:27 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>, "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: ALC883 recording troubles...
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Romano Giannetti" <romano@dea.icai.upcomillas.es>
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

As the mic is working fine, but with this variable DC offset, it felt
like something needed tweaking in the mixer (summation) node. I
understand more about the node connectivity now, and found muting the
front mic mixer input and setting LR gain to 0 at mixer node 23h
addresses the issue:

(from page 42 at ftp://66.104.77.130/pc/audio/ALC883_DataSheet_1.3.pdf)

# ./hda-verb /dev/snd/hwC0D0 0x23 SET_AMP_GAIN_MUTE 0x7180

Vegard - your HD bus enumeration looks similar and I'd bet the vendor
followed the same Realtek application note, so can you give this a
shot too? If not, try mixer node 20h.

My motherboard (Asus P5E-VM HDMI) has front-panel HD-audio (selectable
as legacy in the BIOS) connectors, but I've never been able to get
them working, so left the cables disconnected...surely not a board
design issue, as default pin configuration wouldn't explain the
offset?

Thanks,
  Daniel
-- 
Daniel J Blueman
