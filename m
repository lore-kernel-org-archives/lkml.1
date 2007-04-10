Return-Path: <linux-kernel-owner+w=401wt.eu-S1030686AbXDJVYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030686AbXDJVYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030671AbXDJVYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:24:34 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:40219 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030673AbXDJVYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:24:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:mime-version:content-type:content-transfer-encoding;
        b=VR/0XU7EZTpuBdVdqzFyQsLGABekM1CpM9Xuu3SeY3W0Ab1NWpQBDKfZHXol/ui7dDyOv0gLYFXc7VvRiX4ligNVI1XQuMQBRc/h77ZhfCrAyl1CQOyLr/dFj6i9qbLVL4iGcJ37qoPTut2JfyVpS2V/l9I/Os+4nFf9/mquMXA=
Date: Wed, 11 Apr 2007 00:24:42 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <419106601.20070411002442@gmail.com>
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
CC: David Brownell <david-b@pacbell.net>
Subject: [RFC] GPIODEV API (extension to Generic GPIO API)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kernel lists,

      This is updated and reworked API previously proposed at
http://lkml.org/lkml/2007/3/27/63 . In incorporates received feedback
(suggestions to use established kernel terminology/naming convention
and drop macros). There are also actual tested patches provided this
time, not just pseudocode. So:

Purpose: An extension to 2.6.21-introduced Generic GPIO API, to
provide ability to handle (several) additional platform GPIO chips,
in efficient manner.

Design principles:

1. The new lightweight API is built on top of Generic GPIO API.
Reason: there was previously a proposal to add such capabilities
to Generic GPIO API from the start (thread at
http://lkml.org/lkml/2007/1/1/87), but other requirements were given
more priority at that time, like being able to perform constant
optimization on Generic GPIO API calls, and reduce them to the direct
platform GPIO registers access in this case. To not affect this
beneficial trait, a new lightweight API is introduced, which uses the
same high-level interface, but trades such constant optimizations for
(runtime) extensibility and generalization to any GPIO-providing
device (whereas Generic GPIO API as it is implemented now for few ARM
architectures handles only GPIOs builtin to a CPU).

2. "World is not flat". The real system is structured as following: it
is set of interconnected chips, and some chips have GPIO pins. The
proposed API preserves this target domain model, and doesn't try to
build abstraction on top of it, (like flattening this structured model
so there were scalar GPIO number). Surprisingly (actually, by design),
this solves few issues, inefficiencies, or hardcoded assumptions
which, for example, "flat GPIO namespace" approach has.

3. What is discussed at the end of previous paragraph, achieved by
using "smart", self-describing GPIO identifiers. These identifiers are
vector (actually, 2-element, i.e. pair), and can be seen either as
belonging to structured namespace, where at first level there're GPIO
devices, and at the second - GPIO pins, IDs of which are consequently
local to a given device. Or, as a simple 2D-coordinate, with GPIO chip
as the first coordinate, and GPIO pin as the second.

  "Self-describedness" is achieved by using a reference (i.e. pointer)
to GPIO device object as the first component, and defining a set of
GPIO operations each such device can perform, with operations being
accessible as method calls on device.


  Summing up, technical benefits of proposed solution are:

Minimizes centralized code needed to manage GPIO devices. Actually,
it doesn't minimize it, but eliminates it at all. From the patches which
will follow, it is visible, that there whole 0 bytes of in-kernel
bureaucracies which do superfluous things like adding or subtracting
various magic "base" numbers, searching thru the lists (more often
linearly than binarily), or at least using hashes with hardcoded capacity
and bucket sizes.

Structured namespace approach leads to better scalability - any number
of GPIO devices can be present in system, and there're no hardcoded
limit of any kind.

"Smart" identifiers (== device method approach) leads to good and
jitter-free performance/latency characteristics: there are no lookups
of any kind per se, to find a device which will perform a request -
it is implicitly encoded in GPIO identifiers on which API operates.
The operation call is also as efficient as something extensible can
get - that's indirect function call by pointer.



Final note: The approach/pattern/paradigm discussed here can be reused
for more things than just GPIO API, that's to the large part reason
one this approach is being proposed and argued at all.

Patches follow.

-- 
Best regards,
 Paul                          mailto:pmiscml@gmail.com

