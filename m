Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYKCGD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYKCGD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 01:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYKCGDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 01:03:51 -0500
Received: from smtp5.Stanford.EDU ([171.67.219.85]:47037 "EHLO
	smtp5.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbYKCGDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 01:03:50 -0500
X-Greylist: delayed 674 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Nov 2008 01:03:50 EST
Subject: Re: [alsa-devel] 2.6.26.[6|7] vs. rt11 vs. alsa (usb) midi
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <s5hr65zejxv.wl%tiwai@suse.de>
References: <1224989187.3706.7.camel@localhost.localdomain>
	 <s5hljwazc9i.wl%tiwai@suse.de>
	 <1225229755.3750.1.camel@localhost.localdomain>
	 <s5hr65zejxv.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Sun, 02 Nov 2008 22:52:11 -0800
Message-Id: <1225695131.3772.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-29 at 12:10 +0100, Takashi Iwai wrote:
> At Tue, 28 Oct 2008 14:35:55 -0700,
> Fernando Lopez-Lezcano wrote:
> > 
> > On Mon, 2008-10-27 at 09:13 +0100, Takashi Iwai wrote:
> > > At Sat, 25 Oct 2008 19:46:27 -0700,
> > > Fernando Lopez-Lezcano wrote:
> > > > 
> > > > Hi... anyone out there also having problem with this combination?
> > > >    2.6.26.7 or 2.6.26.6 with 2.6.26.6-rt11 and alsa MIDI
> > > > It looks to me like alsa midi is broken. 
> > > > 
> > > > Probably an interaction with the realtime kernel patch. A Fedora kernel
> > > > based on 2.6.26.6 (2.6.26.6-49 on fc8) works fine, a very similarly
> > > > patched kernel that includes the realtime patch does not. The
> > > > configurations for both are almost the same (today I tried to change
> > > > some of the most obvious differences and rebuild, with the same
> > > > result). 
> > > > 
> > > > No problems with 2.6.24.7-rt21. 

(but on Fedora 9 I get X segfaults with it... so not really usable
either)

> > > > Test: boot, login, plugin an external usb keyboard (Yamaha P250), it is
> > > > recognized, use qjackctl alsa patchbay to connect it to kmidimon,
> > > > kmidimon sees only _one_ midi message and that's it. Kmidimon can't be
> > > > killed after that. 
> > > 
> > > What about other MIDI devices on other bus, e.g. an MPU401 on a PCI
> > > soundcard or so?  There is a possibility of breakage in the USB driver
> > > side, too.
> > 
> > I just tested an RME PCMCIA card + Multiface interface and it shows the
> > same problem. No MIDI messages get through (but the LED in the Multiface
> > blinks). Same hardware booted into 2.6.24.7-rt21 works fine. 
> 
> Then this should be in RT side.  There is no fundamental change
> regarding rawmidi since some time ago...

Hmm, why do you say rawmidi? This is happening with the sequencer
interface, AFAIK. 

I just tested this with the rawmidi.c test program that comes with alsa
and the rawmidi interface _is_ working ("rawmidi -v -i hw:1,0" outputs
the raw bytes being received). 

Now I start qjackctl to patch the sequencer output of the P250 to
kmidimon and I get just one "active sensing" message in the messages
window of kmidimon. This is what I see in the proc/asound/seq/clients
file:

----
$ cat /proc/asound/seq/clients 
Client info
  cur  clients : 6
  peak clients : 6
  max  clients : 192

Client   0 : "System" [Kernel]
  Port   0 : "Timer" (Rwe-)
  Port   1 : "Announce" (R-e-)
    Connecting To: 15:0, 128:0, 129:0
Client  14 : "Midi Through" [Kernel]
  Port   0 : "Midi Through Port-0" (RWe-)
Client  15 : "OSS sequencer" [Kernel]
  Port   0 : "Receiver" (-we-)
    Connected From: 0:1
Client  20 : "P-250" [Kernel]
  Port   0 : "P-250 MIDI 1" (RWeX)
    Connecting To: 129:0
  Port   1 : "P-250 MIDI 2" (-We-)
Client 128 : "Client-128" [User]
  Port   0 : "qjackctl" (-W--)
    Connected From: 0:1
  Input pool :
    Pool size          : 200
    Cells in use       : 0
    Peak cells in use  : 3
    Alloc success      : 5
    Alloc failures     : 0
Client 129 : "KMidimon" [User]
  Port   0 : "input" (-We-)
    Connected From: 0:1, 20:0
  Output pool :
    Pool size          : 500
    Cells in use       : 0
    Peak cells in use  : 0
    Alloc success      : 0
    Alloc failures     : 0
  Input pool :
    Pool size          : 200
    Cells in use       : 0
    Peak cells in use  : 2
    Alloc success      : 4
    Alloc failures     : 0
----

Now I quit kmidimon...

----
$ cat /proc/asound/seq/clients
----

Hangs!
Can't ctrl-c out of it. 
Kmidimon is (sort of) still around:

----
nando     7696  0.3  0.0      0     0 ?        Zl   22:41   0:01
[kmidimon] <defunct>
----

Rawmidi does not work anymore, of course, hangs and can't be ctrl'c'ed
either. Everything that touches midi seems to hang waiting for something
that is never going to happen. And this only appears to happen when I
try to use the sequencer api. Before that the rawmidi program happily
prints midi bytes as they arrive. 

Maybe this points to a possible culprit?
Any more data I could provide that would be useful?
Any help in debugging this would be appreciated. At this point no
realtime kernel is usable for the tasks I need it for. 

-- Fernando


