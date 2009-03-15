Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbZCOJVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbZCOJVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 05:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbZCOJVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 05:21:23 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:51371 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbZCOJVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 05:21:21 -0400
Date: Sun, 15 Mar 2009 10:21:17 +0100
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Andreas Mohr <andi@lisas.de>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
Message-ID: <20090315092117.GA1567@rhlx01.hs-esslingen.de>
References: <s5h3ai11dpt.wl%tiwai@suse.de> <20081109151323.GA18705@rhlx01.hs-esslingen.de> <s5h7i7c916e.wl%tiwai@suse.de> <20081109200929.GA29333@rhlx01.hs-esslingen.de> <s5hiqqtkxqr.wl%tiwai@suse.de> <491B0D38.1050207@gmail.com> <20081112180519.GA21919@rhlx01.hs-esslingen.de> <491DBDEA.9010104@gmail.com> <492856C2.8000707@gmail.com> <s5hy6z9i44h.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hy6z9i44h.wl%tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Nov 24, 2008 at 03:35:10PM +0100, Takashi Iwai wrote:
> At Sat, 22 Nov 2008 21:00:18 +0200,
> Maxim Levitsky wrote:
> > 
> > Maxim Levitsky wrote:
> > > Andreas Mohr wrote:
> > >> Hi,
> > >>
> > >> On Wed, Nov 12, 2008 at 07:07:04PM +0200, Maxim Levitsky wrote:
> > >>> I pretty much studied the datasheet and driver, and this is what I 
> > >>> found:
> > >>> btw, my acer 5720 and aspire one share same ALC268.
> > >>> Some stuff is trivially fixable, some seems to be unfixable at all:
> > >>
> > >> Wow, what an extremely in-depth analysis!
> > >> I just intended to dive into getting mic routing corrected myself,
> > >> thus you saved me a lot of time!
> > >>
> > >>> model=acer is used on my regular laptop.
> > >>> model-acer-aspire is used on aspire one laptop, and it needs to be 
> > >>> renamed, as both are aspire.
> > >>
> > >> +1 (your analysis of both being rather different - as already pondered -
> > >> confirms this necessity)
> > >>
> > >>> And now for unfixable problems:
> > >>>
> > >>> 1) There is strong DC offset on all inputs.
> > >>> it is even different on left/right and depends on capture volume.
> > >>> I tried to change the VREF only param that could help, but it doesn't.
> > >>> I feel that this is hardware flaw.
> > >>> (It is possible that voltage on inputs is created by circuit made by 
> > >>> acer, and then ALC268 amplifies it.)
> > >>
> > >> Sounds like really bad circuit design then.
> > >> One would think that the Intel HDA architecture might have builtin
> > >> measures to compensate for this if needed? DC offset issues on
> > >> soundcards aren't exactly a new phenomenon after all...
> > >>
> > >>> Lastly I noticed that datasheet mentions so called 'coefficients':
> > >>> the codecs exposes lots of internal and undocumented registers using 
> > >>> set address/ get/set value scheme.
> > >>> maybe some of above bugs are fixable there, but ether realtek has to 
> > >>> provide data for that or reverse engineering of
> > >>> windows driver is required.
> > >>
> > >> I've actually had a peek at the .inf files since I thought that it would
> > >> already contain register values in those registry keys that it creates on
> > >> install, but yeah, that's all in-driver it seems.
> > >> Probably time to ask Acer about specifics, especially since I didn't spot
> > >> any hda-intel changes in their linux-2.6.23.9lw source.
> > >>
> > >> Thank you very much,
> > >>
> > >> Andreas Mohr
> > > 
> > > Small update:
> > > 
> > > 1) The dc offset isn't present on aspire one, really is a circuit design 
> > > bug I guess 2) Internal mic works perfectly on aspire one, can reproduce 
> > > the strange behaver at all,
> > > Probably this was mixer bug.
> > Finally, I found how to reproduce that bug,
> > I mean to get normal volume on internal mic, I have to increase volume
> > only on left or right channel.
> > 
> > So, this happens always, and _only_ when recording _mono_ sound from internal
> > mic.
> > 
> > Since hardware doesn't support hardware mono input, tested with -D hw:0
> > I suspect this to be alsa-lib bug, any ideas?
> > Happens with arecord -D plughw:0 -c1 .
> 
> What does show with -v option?

OK, I could fully reproduce this now (sorry for the delay!).

Currently 2.6.28, u8.10, model acer-aspire, libasound2 1.0.17a-0ubuntu4,
libasound2-plugins 1.0.17-0ubuntu5.

Recording from i-Mic does work (minus some pretty annoying background noise)
if in gamix I open either left _or_ right channel of the "Capture" control,
but the more both channel sliders progress towards an (almost) equal level,
the more the recording gets reduced to bit changes distantly resembling
the time curve of the recorded signal (but this is not a linear effect,
only the last 5% difference of the slider are dramatic).
IOW you get a "bit buzzing" which clearly distantly resembles the speech
you recorded, something like
"Hello, Test!" --> "crch........crch......crch..."
                   "(H).ee.(l)..oooo..(T).eee.(st)."
I'm wondering whether these are MSB bit, not LSB, remains of the original
signal here... (since they are clearly audible which LSB wouldn't be)

Anyway, we clearly have some differential logic of the two channels
here, which certainly shouldn't be the case, IOW most likely a bug.


Working test (Capture sliders NOT equal, recorded signal audible):

andi@andinet:~$ arecord -v -D plughw:0 -c1 test.wav
Recording WAVE 'test.wav' : Unsigned 8 bit, Rate 8000 Hz, Mono
Plug PCM: Rate conversion PCM (48000, sformat=U8)
Its setup is:
  stream       : CAPTURE
  access       : RW_INTERLEAVED
  format       : U8
  subformat    : STD
  channels     : 1
  rate         : 8000
  exact rate   : 8000 (8000/1)
  msbits       : 8
  buffer_size  : 2730
  period_size  : 682
  period_time  : 85333
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 682
  period_event : 0
  start_threshold  : 1
  stop_threshold   : 2730
  silence_threshold: 0
  silence_size : 0
  boundary     : 178913280
Slave: Route conversion PCM (sformat=S16_LE)
  Transformation table:
    0 <- 0*0.5 + 1*0.5
Its setup is:
  stream       : CAPTURE
  access       : MMAP_INTERLEAVED
  format       : U8
  subformat    : STD
  channels     : 1
  rate         : 48000
  exact rate   : 48000 (48000/1)
  msbits       : 8
  buffer_size  : 16384
  period_size  : 4096
  period_time  : 85333
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 4096
  period_event : 0
  start_threshold  : 6
  stop_threshold   : 16384
  silence_threshold: 0
  silence_size : 0
  boundary     : 1073741824
Slave: Hardware PCM card 0 'HDA Intel' device 0 subdevice 0
Its setup is:
  stream       : CAPTURE
  access       : MMAP_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 48000
  exact rate   : 48000 (48000/1)
  msbits       : 16
  buffer_size  : 16384
  period_size  : 4096
  period_time  : 85333
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 4096
  period_event : 0
  start_threshold  : 6
  stop_threshold   : 16384
  silence_threshold: 0
  silence_size : 0
  boundary     : 1073741824
^CAborted by signal Interrupt...
andi@andinet:~$ aplay test.wav 
Playing WAVE 'test.wav' : Unsigned 8 bit, Rate 8000 Hz, Mono
andi@andinet:~$



Non-working test (Capture sliders are equal):

andi@andinet:~$ arecord -v -D plughw:0 -c1 test.wav
Recording WAVE 'test.wav' : Unsigned 8 bit, Rate 8000 Hz, Mono
Plug PCM: Rate conversion PCM (48000, sformat=U8)
Its setup is:
  stream       : CAPTURE
  access       : RW_INTERLEAVED
  format       : U8
  subformat    : STD
  channels     : 1
  rate         : 8000
  exact rate   : 8000 (8000/1)
  msbits       : 8
  buffer_size  : 2730
  period_size  : 682
  period_time  : 85333
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 682
  period_event : 0
  start_threshold  : 1
  stop_threshold   : 2730
  silence_threshold: 0
  silence_size : 0
  boundary     : 178913280
Slave: Route conversion PCM (sformat=S16_LE)
  Transformation table:
    0 <- 0*0.5 + 1*0.5
Its setup is:
  stream       : CAPTURE
  access       : MMAP_INTERLEAVED
  format       : U8
  subformat    : STD
  channels     : 1
  rate         : 48000
  exact rate   : 48000 (48000/1)
  msbits       : 8
  buffer_size  : 16384
  period_size  : 4096
  period_time  : 85333
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 4096
  period_event : 0
  start_threshold  : 6
  stop_threshold   : 16384
  silence_threshold: 0
  silence_size : 0
  boundary     : 1073741824
Slave: Hardware PCM card 0 'HDA Intel' device 0 subdevice 0
Its setup is:
  stream       : CAPTURE
  access       : MMAP_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 48000
  exact rate   : 48000 (48000/1)
  msbits       : 16
  buffer_size  : 16384
  period_size  : 4096
  period_time  : 85333
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 4096
  period_event : 0
  start_threshold  : 6
  stop_threshold   : 16384
  silence_threshold: 0
  silence_size : 0
  boundary     : 1073741824
^CAborted by signal Interrupt...
andi@andinet:~$ aplay test.wav 
Playing WAVE 'test.wav' : Unsigned 8 bit, Rate 8000 Hz, Mono
andi@andinet:~$


I did a diff of the two test logs above, and they were identical.


Ekiga recording test does work with the sliders being opposite,
but audio quality in general is very poor and buggy (only the first
seconds were played back audibly, and in general the speakers have some
background noise which is being switched on/off from time to time at will,
and somehow the whole codec / setup doesn't seem solid).

Any ideas?

Will now try to upgrade to newer ALSA userspace at least.

Thanks,

Andreas Mohr
