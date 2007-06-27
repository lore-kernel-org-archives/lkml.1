Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbXF0QZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbXF0QZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbXF0QZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:25:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:30353 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbXF0QZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:25:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=iHP3KvU93H75JnS0qLup7XV11KbdRZJspgAztc+KjcLdlvRocWuNH6CfMKq1mr1e6eb+ehrzgOMOiNS54UdW4/eaSDU53oO6sMETlYuWELIGUdpT58an9X/lRfEf1B8XxdLTRd2pD/9WjL6pK6Drg5MKw6kwxa2obuO7atplk58=
From: Andreas Hartmetz <ahartmetz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Date: Wed, 27 Jun 2007 18:25:17 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706271825.17459.ahartmetz@gmail.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > The track record of ALSA for me goes like this:
>  > - dmix finally started working automatically (at least on my Kubuntu
>  >  system)  about one year ago, about five years after everybody could see
>  >  that this was  badly needed.
>
>  I don't remember when it happened, but I do remember that I suddenly
>  had to manually disable dmix to stop it messing around with my sound.
>  I don't need it, and I certainly don't like libraries doing random IPC
>  behind my back.
>
I don't like random applications blocking my sound card.
Joe user wants to play sound, and he couldn't care less about "random IPC" or 
what-fucking-ever.
Dmix using the low quality sampling rate converter by default was another bad 
decision.
You are concerned about your precious audio quality? Me too. Most people, 
however, are using god-awful plastic speakers for twenty euros and shitty 
onboard sound chips. Sad but true.

>  > - Different desktop environments have different sound daemons to
>  > paper over the weaknesses of ALSA (no dmix by default / unfriendly
>  > API), which creates new problems. Yes there are other reasons for
>  > sound daemons, but I doubt anybody would have come up with the idea
>  > if it wasn't for ALSA.
>
>  Those sound daemons were around long before ALSA was even conceived.
>

ALSA appeared in 1999, KDE 2 with aRtsd (another catastrophic failure of 
technology) was released in october 2000.
Linux 2.6.0 seems to have appeared in 2003, so you are right for realistic 
values of "being around".

>  That sounds like a minor glitch that should be easily remedied if you
>  file a proper bug report. Have you tried?
>
No, I kinda gave up on ALSA after reading its API (rather "functions 
that happen to be exported") documentation and kinda hoped it would go away 
ASAP.

[long rant on ALSA's developer "friendliness"]
If you want to see an example try this one:
http://www.alsa-project.org/alsa-doc/alsa-lib/hcontrol.html
or this one
http://www.alsa-project.org/alsa-doc/alsa-lib/group___h_control.html#g881a1bbb1e95b7bcadc5c2a88124c3d1
and now program against it! Having fun already?

Observe how "HCTL"s seem to be used everywhere, and the documentation is
"typedef struct _snd_hctl_elem snd_hctl_elem_t : HCTL element handle". Wow.

the struct looks like this:

struct _snd_hctl_elem {
        snd_ctl_elem_id_t id;           /* must be always on top */
        struct list_head list;          /* links for list of all helems */
        int compare_weight;             /* compare weight (reversed) */
        /* event callback */
        snd_hctl_elem_callback_t callback;
        void *callback_private;
        /* links */
        snd_hctl_t *hctl;               /* associated handle */
};
Notice how compare_weight should probably be called comparison_weight or 
priority, or relative_priority, or rel_priority or (...). The comment is 
worse than no comment. The author couldn't be bothered to use a dictionary? I 
think he wanted to tell us whether higher priorities have higher or lower 
numbers, but I still don't know which.
callback_private should be callback_opaque. The construct has always been 
called opaque pointer. If it was private it wasn't in this struct.
What about "must be always on top"??? Is it trying to tell us that you should 
not randomize the struct layout?
Bonus points for using abbrvns ("helems") in cmts, thy r mch mr nformtv tht 
wy.
There are two other structs of the same quality in the same header file
alsa-lib/control/control_local.h.
(control_local? As opposed to... remote? With a different interface or what? 
It doesn't make any sense.)

This mess probably couldn't have survived a real review by the kernel 
community.

For comparison, a comment taken from KDE's Phonon, copyright Matthias Kretz:
/**
 * This signal is emitted whenever the volume has changed. As the
 * volume can change without a call to setVolume (calls over dbus)
 * this is important
 * to keep a widget showing the current volume up to date.
 */
 void volumeChanged(qreal newVolume);

Spot the difference?

Kernel or user space, again:
Put everything in kernel OR userspace but not both. Either is OK, but the 
arguably more "modern" approach is userspace for error resilience and easy 
hacking (i.e. more features faster). Latency is an issue? - Well you can't 
play sound without userspace creating it so you're not adding any new 
problems.
Kernel only would have the advantage of being able to present "everything as a 
file" which is a good tradition. And no IPC.
ALSA took the disadvantages of both approaches and added the disadvantage of 
having to get two chunks of code to get it working. It takes a twisted mind 
to have two obvious right options and pick the third, obscure, and wrong 
option. So sampling rate conversion is hard ("too dangerous for the kernel"), 
boo hoo. It sure isn't more difficult to get right than a filesystem. Deal 
with it.

History of ALSA:
I examined the lkml archive 1999 to 2002 a bit. There was much talk about 
using all the DSP, bass boost, and other sundry hardware capabilities of 
cards just appearing at the time. The focus was on adding support for 
everything which
a) didn't happen (DSPs almost never get used to their full potential, I think)
b) somehow became uninteresting over the years. I don't want to "enhance" my 
sound with cheap DSP effects, I'll take a good stereo, thank you very much.
c) is only relevant for games because you don't want to use any effect off 
your card in professional audio applications
d) is plain stupid if you don't know what exactly you are going to need 
beforehand.

Sorry for the long rant - I've regularly gotten worked up about ALSA in the 
last few years whenever I got in touch with it. Mostly as a user and once as 
a potential client developer, but I was disgusted and turned away.

>  > - On my IBM/Lenovo R50e notebook with Intel chipset sound didn't
>  > work before I "muted" the "headphone jack sense" control in
>  > alsamixer. That took two hours or so. When both the master volume
>  > and the PCM volume control are set to 100% I get really bad clipping
>  > problems.
>
>  Shoddy hardware. Don't blame the drivers for that.
>
Random quote from the internet: "It all sounds perfectly reasonable until you 
have to explain to your granny why her PC sounded like shit over the last 
couple of months."
This can be fixed in the driver. It's called a quirk.

>  Yes, API and configuration file syntax aside, the ALSA developers are
>  always friendly and responsive.
>
Yes. It just seems like nobody feels in charge to revisit the big picture 
issues where things really went wrong.
The last signals from Jaroslav Kysela I found on the net look like he is 
convinced of having created a great architecture, especially for professional 
audio applications(*). He is employed by Novell like Takashi, apparently, 
which won't make Takashi feel too adventurous, right? My guess is that 
Jaroslav is (officially or not) assigned to everything but drivers, and he is 
just not doing anything ALSA at all.
Meanwhile, ALSA continues to be crap and annoy people.

(*) ALSA is not lacking in raw capability, to be sure.

>  > (*) I am not representing KDE in an official way at all, but I can
>  > say that KDE developers generally put *much* effort into making APIs
>  > as logical and friendly as they possibly can.
>
>  I've still not, after all these years, managed to figure out what KDE
>  (or Gnome) is supposed to be good for. I'm not missing anything from
>  my window manager, xterm and xemacs setup.

Maybe you could try a recent KDE or show me the command-line equivalents of 
Amarok or KPDF or Gwenview :)
