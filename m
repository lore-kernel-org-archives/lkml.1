Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbZFYH1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbZFYH1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 03:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZFYH1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 03:27:14 -0400
Received: from stz-softwaretechnik.de ([217.160.223.211]:2998 "EHLO
	stlx01.stz-softwaretechnik.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752916AbZFYH1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 03:27:14 -0400
Date: Thu, 25 Jun 2009 09:26:41 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: io-scheduler tuning for better read/write ratio
Message-ID: <20090625072641.GB16642@p15145560.pureserver.info>
References: <4A37CB2A.6010209@davidnewall.com> <x49iqinys2k.fsf@segfault.boston.devel.redhat.com> <20090624072554.GA16642@p15145560.pureserver.info> <200906241057.41227.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906241057.41227.a1426z@gawab.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi schrieb:
> Ralf Gross wrote:
> > The main problem is with bacula. It reads/writes from/to two
> > spoolfiles on the same device.
> >
> > I get the same behavior with 2 dd processes, one reading from disk, one
> > writing to it.
> >
> > Here's the output from dstat (5 sec intervall).
> >
> > --dsk/md1--
> > _read _writ
> >   26M   95M
> >   31M   96M
> >   20M   85M
> >   31M  108M
> >   28M   89M
> >   24M   95M
> >   26M   79M
> >   32M  115M
> >   50M   74M
> >  129M   15k
> >  147M 1638B
> >  147M    0
> >  147M    0
> >  113M    0
> >
> >
> > At the end I stopped the dd process that is writing to the device, so you
> > can see that the md device is capable of reading with >120 MB/s.
> >
> > I did this with these two commands.
> >
> > dd if=/dev/zero of=test bs=1MB
> > dd if=/dev/md1 of=/dev/null bs=1M
> 
> Try changing /proc/sys/vm/dirty_ratio = 1

$cat /proc/sys/vm/dirty_ratio
1


$dstat -D md1 -d 5
--dsk/md1--
_read _writ
  18M   18M
   0     0 
 820k  101M
  18M  113M
  26M   73M
  26M  110M
  32M  100M
  19M  111M
  13M  117M
  13M  142M
  32M   88M
  26M   99M
  38M   58M

No change. Even setting dirty_ratio to 100 didn't show any difference.


With the cfq scheduler and slice_idle = 24 (trial and error) I get better
results. Itried this before, but the overall throughput was a bit lower than
with deadline.

It seems that I can not tune deadline to get the samet behaviour.

--dsk/md1--
_read _writ
  18M   18M
  25M   77M
  51M   65M
  51M   47M
  62M   45M
  53M   28M
  45M   43M
  46M   47M
  47M   42M
  51M   41M
  38M   51M
  51M   40M
  45M   40M
  58M   42M
  69M   41M
  72M   42M
 122M    0
 141M  340k
--dsk/md1--
_read _writ
 139M  562k
 136M    0
 141M   13k
  64M    0
1638B  104M
   0   110M
   0   122M
   0   104M
   0   108M

The last numbers are for reading/writing only.

Ralf
