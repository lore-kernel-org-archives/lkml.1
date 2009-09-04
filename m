Return-Path: <linux-kernel-owner+w=401wt.eu-S932926AbZIDDXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926AbZIDDXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 23:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932674AbZIDDXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 23:23:50 -0400
Received: from mail-pz0-f190.google.com ([209.85.222.190]:48701 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638AbZIDDXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 23:23:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent:message-id;
        b=TqMfiKl9unAhhn8CxTeu5mCj7svGbpOhhLwkpciWaVeVvn2mmb7Y2nigfD4rGbI0Lr
         ruOHyWy8ZDbKp/OKm6PAEN1j4cY64jXf1NGsKT92IwIRZCU1Z4ZvA4MjErQtlBDCUrJx
         IELKr6S/bjj8HiO+oL/n+MR8pWqWbuOCPpATE=
Date: Thu, 3 Sep 2009 20:23:43 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Rabin Vincent <rabin@rab.in>
Subject: Re: INFO: possible recursive locking detected ps2_command
References: <c4e36d110807310241n512b01e4v898e883d740de879@mail.gmail.com> <20080731145739.fe8923be.akpm@linux-foundation.org> <20080801030444.GB18953@anvil.corenet.prv> <1218192589.8625.88.camel@twins> <20080808082930.ZZRA012@mailhub.coreip.homeip.net> <c4e36d110909031548y38276e0cjfc5eee7bfdba8e50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c4e36d110909031548y38276e0cjfc5eee7bfdba8e50@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090904035641.2B5B6526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 12:48:45AM +0200, Zdenek Kabelac wrote:
> 2008/8/8 Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> > On Fri, Aug 08, 2008 at 12:49:49PM +0200, Peter Zijlstra wrote:
> >> On Thu, 2008-07-31 at 23:04 -0400, Dmitry Torokhov wrote:
> >> > On Thu, Jul 31, 2008 at 02:57:39PM -0700, Andrew Morton wrote:
> >> > >
> >> > > (cc linux-input)
> >> > >
> >> > > On Thu, 31 Jul 2008 11:41:25 +0200
> >> > > "Zdenek Kabelac" <zdenek.kabelac@gmail.com> wrote:
> >> > >
> >> > > > Hi
> >> > > >
> >> > > > During mouse unplugging from psaux connector from the laptops' docking
> >> > > > station I've got attached INFO trace.
> >> > > > (laptops still has synaptics device)
> >> > > >
> >> >
> >> > Dell?
> >> >
> >> > > > Also for unknown reason to me  psaux mouse & synaptic device do not
> >> > > > work somehow together - is it hw limitation
> >> > > > of /dev/input/mice  interface?
> >> > > > (USB mouse and synaptics do work quite well together)
> >> > > >
> >> > > > [ INFO: possible recursive locking detected ]
> >> > > > 2.6.27-rc1 #48
> >> > >
> >> > > (it's 2.6.27-rc1)
> >> > >
> >> >
> >> > Peter, here is the trace we talked about long time ago. For some reason
> >> > lockdep annotation only works once. If reconnect is forced or psmouse
> >> > module is reloaded lockdep starts complaining about passthrough port.
> >>
> >> Bit puzzling - and I don't have any ps2 hardware around to test with
> >> (nor do I normally use modules - but that is fixable of course).
> >>
> >> Does Rabin's patch help?
> >>
> >>   http://lkml.org/lkml/2008/8/7/329
> >>
> >
> > I doubt it resolves problem fully because it only takes care of module
> > unload. I can easily trip lockdep by reconnecting the device. Just to
> > give some more details about the problem:
> >
> >  - synaptics touchpads have a pass-through port that allows to connect
> >   either external mouse or maybe a trackpoint device. Both devices
> >   are represented by 'serio' structures and are handled by the same
> >   driver (psmouse).
> >
> >  - as far as I know we have proper locking there and lockdep
> >   annotatinos were added to lockdep to reflect the nesting of the
> >   serio ports.
> >
> >  - if child port (pass-through port) is destroyed and recreated (due
> >   to module unload, or because user requested reconnect through sysfs
> >   or system-initiated reconnect) lockdep starts complaining although
> >   the new child port should still have the same "depth" as the old
> >   one.
> >
> 
> Well just noticed this issue again in my log - during resume operation
> - thus no external mouse connection in the game this time:
> 

External mouse does not have to be connected, the fact that you have
a pass-through serio port is enough to trigger this warning.

-- 
Dmitry
