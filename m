Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYHHMox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYHHMox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 08:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYHHMoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 08:44:44 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:10166 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbYHHMon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 08:44:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ki7rTIcB6Vj0zqLyZis5ut9OjGusLxlaJvZ5/q07djz5Xy61yn8dDFMemFyMbor3Ia
         7L7RxUXyMuS3fKn9jGm0vFBUEOCCMY1CAIpKvyDvvcnYmFN2LrJEYZQx4R29ynIONv9l
         thZ2GO9EmEYVc03pQUkjYAl2jUFsLUJAia8g0=
Date: Fri, 8 Aug 2008 08:44:33 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Rabin Vincent <rabin@rab.in>
Subject: Re: INFO: possible recursive locking detected ps2_command
Message-ID: <20080808082930.ZZRA012@mailhub.coreip.homeip.net>
References: <c4e36d110807310241n512b01e4v898e883d740de879@mail.gmail.com> <20080731145739.fe8923be.akpm@linux-foundation.org> <20080801030444.GB18953@anvil.corenet.prv> <1218192589.8625.88.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218192589.8625.88.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 12:49:49PM +0200, Peter Zijlstra wrote:
> On Thu, 2008-07-31 at 23:04 -0400, Dmitry Torokhov wrote:
> > On Thu, Jul 31, 2008 at 02:57:39PM -0700, Andrew Morton wrote:
> > > 
> > > (cc linux-input)
> > > 
> > > On Thu, 31 Jul 2008 11:41:25 +0200
> > > "Zdenek Kabelac" <zdenek.kabelac@gmail.com> wrote:
> > > 
> > > > Hi
> > > > 
> > > > During mouse unplugging from psaux connector from the laptops' docking
> > > > station I've got attached INFO trace.
> > > > (laptops still has synaptics device)
> > > > 
> > 
> > Dell?
> > 
> > > > Also for unknown reason to me  psaux mouse & synaptic device do not
> > > > work somehow together - is it hw limitation
> > > > of /dev/input/mice  interface?
> > > > (USB mouse and synaptics do work quite well together)
> > > > 
> > > > [ INFO: possible recursive locking detected ]
> > > > 2.6.27-rc1 #48
> > > 
> > > (it's 2.6.27-rc1)
> > > 
> > 
> > Peter, here is the trace we talked about long time ago. For some reason
> > lockdep annotation only works once. If reconnect is forced or psmouse
> > module is reloaded lockdep starts complaining about passthrough port.
> 
> Bit puzzling - and I don't have any ps2 hardware around to test with
> (nor do I normally use modules - but that is fixable of course).
> 
> Does Rabin's patch help?
> 
>   http://lkml.org/lkml/2008/8/7/329
> 

I doubt it resolves problem fully because it only takes care of module
unload. I can easily trip lockdep by reconnecting the device. Just to
give some more details about the problem:

 - synaptics touchpads have a pass-through port that allows to connect
   either external mouse or maybe a trackpoint device. Both devices
   are represented by 'serio' structures and are handled by the same
   driver (psmouse).

 - as far as I know we have proper locking there and lockdep
   annotatinos were added to lockdep to reflect the nesting of the
   serio ports.

 - if child port (pass-through port) is destroyed and recreated (due
   to module unload, or because user requested reconnect through sysfs
   or system-initiated reconnect) lockdep starts complaining although
   the new child port should still have the same "depth" as the old
   one.

Thanks!

-- 
Dmitry
