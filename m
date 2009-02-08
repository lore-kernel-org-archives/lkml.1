Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbZBHA4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbZBHA4L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 19:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbZBHAz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 19:55:57 -0500
Received: from science.horizon.com ([192.35.100.1]:19593 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751261AbZBHAz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 19:55:56 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Feb 2009 19:55:56 EST
Message-ID: <20090208004914.21448.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Sat, 07 Feb 2009 19:49:14 -0500
To: linux@horizon.com, giometti@enneenne.com, linux-kernel@vger.kernel.org,
       LinuxPPS@ml.enneenne.com
Subject: LinuxPPS kernel interface
References: <9dd2f03a0810280213v42811184pb14d80f90529d1d5@mail.gmail.com>
 <20081028111414.19650.qmail@science.horizon.com>
 <20081028144735.GC28518@tekkaman>
 <20081028181335.29352.qmail@science.horizon.com>
 <20081028181546.GM11339@tekkaman>
 <20090206142231.22425.qmail@science.horizon.com>
 <20090206143703.GC7975@enneenne.com>
 <20090206144752.5195.qmail@science.horizon.com>
 <20090206145553.GD7975@enneenne.com>
 <20090206145932.10638.qmail@science.horizon.com>
 <20090206152156.GE7975@enneenne.com>
 <20090206225326.14093.qmail@science.horizon.com>
In-Reply-To: <20090206225326.14093.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Be aware that this is crossposted to linux-kernel and LinuxPPS.
The latter mailing list rejects mail from non-subscribers, so
the discussion on linux-kernel is likely to be more complete.)

LinuxPPS is an implementation of the PPS API from RFC 2783.
That's a function-call interface, and it's up to the implementation
to determine how to partition responsibility between the kernel and
the userspace library.

I just posted to the LinuxPPS maining list a series of patches which
change the semantics of the LinuxPPS kernel interface so most of the
mode bits are per-fd rather than global.  You can have one user listening
for assert events and the other listening for clear events.

So far, nothing has changed the interface for any single user; the
only difference is that multiple users now interact less.

One thing I got working is that POLLIN now properly waits until a new
PPS event is available.

That makes it possible to implement the (required) time_pps_fetch()
function without passing the timeout to the PPS_FETCH ioctl.  Instead,
time_pps_fetch() can be implemented as a call to poll(2) followed by an
immediate ioctl.

However, other kernel interface cleanups seem possible.  Here's my list
of possible kernel interface changes.  I'd like some design review and
comments on the ideas.
(Note that some of them are mutually exclusive!)

- Eliminate the timeout argument and the whole struct pps_fdata thing.
  Do the timeout with ppoll, and then get the last event.

- Change PPS_FETCH to never wait.  Instead, it always immediately returns
  the most recently captures PPS events.  If you want to wait, use poll.

- Move the PPS_OFFSET feature to user space.  That requires making
  a pps_handle_t a pointer to a structure containing the offsets.

- Move the PPS_CAPTURE mode bits to use space.  Rather than telling
  the kernel the mode of the current fd, just have the two different
  edges reported by different poll bits (POLLPRI and POLLRDBAND?) which
  userspace can wait for whenever it wishes.  (POLLIN would get both,
  of course.)

- Add a read(2) interface.  Suggestions for the format are appreciated.
  I imagine an ASCII interface:
  assert <sequence> <seconds>.<fraction>\n
  clear <sequence> <seconds>.<fraction>\n
  But maybe something else?

- Replace PPS_FETCH with the above interface?  Or is the dual binary/ASCII
  conversion too annoying?

- Add a clock type specification to the kernel interface?  Or is
  CLOCK_REALTIME always okay?

- I'd like to add support for serial port signals other than DCD.
  The 8250 hardware treats CTS and DSR just the same, and one edge of RI
  can be trapped.  Any idea how to do that?  Just instantiate multiple
  PPS devices?  Should there be a better device naming convention?

- Think about the ECHO flags.  The RFC leaves it implementation-defined
  which line is used for output, and people seem to use the RTS line.
  Bascially, the interrupt handler does a TIOCMBIS/TIOCMBIC ioctl to
  toggle the RTS line.  Is this okay?  How should it interact with CRTSCTS?
