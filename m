Return-Path: <linux-kernel-owner+w=401wt.eu-S1762759AbZJONgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762759AbZJONgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 09:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762749AbZJONgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 09:36:05 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:26113 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438AbZJONgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 09:36:04 -0400
MIME-Version: 1.0
Message-ID: <c7f37ead-3cf2-4277-a44e-425a7b940d31@default>
Date: Thu, 15 Oct 2009 06:27:24 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       arch/x86 maintainers <x86@kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, chris.mason@oracle.com
Subject: RE: [Xen-devel] [PATCH 05/12] xen/pvclock: add monotonicity check
In-Reply-To: <4AD6B1F0.6030904@goop.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AD72399.004D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 10/14/09 20:26, Dan Magenheimer wrote:
> > As long as we are going through the trouble of making
> > this monotonic, shouldn't it be monotonically increasing
> > (rather than just monotonically non-decreasing)?  The
> > rdtsc instruction and any suitably high-precision
> > hardware timer will never return the same value
> > on subsequent uses so this might be a reasonable
> > precedent to obey.  E.g.
> >
> > +	return ret > xen_clocksource.cycle_last ?
> > +		ret : ++xen_clocksource.cycle_last;
> 
> No, cycle_last isn't updated on every read, only on timer ticks.  This
> test doesn't seem to be intended to make sure that every
> clocksource_read is globally monotonic, but just to avoid 
> some boundary
> conditions in the timer interrupt.  I just copied it directly from
> read_tsc().

I understand but you are now essentially emulating a
reliable platform timer with a potentially unreliable
(but still high resolution) per-CPU timer AND probably
delivering that result to userland.

Read_tsc should only be used if either CONSTANT_TSC
or TSC_RELIABLE is true, so read_tsc is guaranteed
to be monotonically-strictly-increasing by hardware
(and enforced for CONSTANT_TSC by check_tsc_warp
at boot).
