Return-Path: <linux-kernel-owner+w=401wt.eu-S1763021AbXHWNoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763021AbXHWNoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 09:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761252AbXHWNoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 09:44:05 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:51925 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1761276AbXHWNoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 09:44:04 -0400
Message-ID: <387876639.03284@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 23 Aug 2007 21:43:59 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Richard Ballantyne <richardballantyne@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       James Courtier-Dutton <James@superbug.co.uk>
Subject: Re: file system for solid state disks
Message-ID: <20070823134359.GB5576@mail.ustc.edu.cn>
References: <6278d2220708230155j18248f2cr3cc697a7acbaa930@mail.gmail.com> <46CD8173.1020606@superbug.co.uk> <6278d2220708230556hb87a675u6ad49989d4adf237@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2220708230556hb87a675u6ad49989d4adf237@mail.gmail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 01:56:17PM +0100, Daniel J Blueman wrote:
> Hi Fengguang,
> 
> On 23/08/07, James Courtier-Dutton <James@superbug.co.uk> wrote:
> > Daniel J Blueman wrote:
> > > On 23 Aug, 07:00, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> > >> On Aug 23 2007 01:01, Richard Ballantyne wrote:
> > >>
> > >>> What file system that is already in the linux kernel do people recommend
> > >>> I use for my laptop that now contains a solid state disk?
> > >>>
> > >> If I had to choose, the list of options seems to be:
> > >>
> > >> - logfs
> > >>   [unmerged]
> > >>
> > >> - UBI layer with any fs you like
> > >>   [just a guess]
> > >>
> > >> - UDF in Spared Flavor (mkudffs --media-type=cdrw --utf8)
> > >>   [does not support ACLs/quotas]
> > >
> > > Isn't it that with modern rotational wear-levelling, re-writing hot
> > > blocks many times is not an issue, as they are internally moved around
> > > anyway? So, using a journalled filesystem such as ext3 is still good
> > > (robustness and maturity in mind). Due to lack of write buffering,
> > > perhaps a wandering log (journal) filesystem would be more suitable
> > > though? I use ext3 on my >35MB/s compact flash filesystem.
> > >
> > > I can see there being advantage in selecting a filesystem which is
> > > lower complexity due to no additional spatial optimisation complexity,
> > > but those advantages do buy other efficiency (eg the Orlov allocator
> > > reducing fragmentation, thus less overhead), right?
> > >
> > > Also, it would be natural to employ 'elevator=none', but perhaps there
> > > is a small advantage in holding a group of flash blocks 'ready' (like
> > > SDRAM pages being selected on-chip for lower bus access latency) -
> > > however this no longer holds when logical->physical remapping is
> > > performed, so perhaps it's better without an elevator.
> > >
> > > Clearly, benchmarks speak...but perhaps it would make sense to have
> > > libata disable the elevator for the (compact) flash block device?
> > >
> > > Daniel
> >
> > Also, sector read ahead will actually have a performance impact on
> > Flash, instead of speed things up with a spinning disc.
> > For example, a request might read 128 sectors instead of the one
> > requested at little or no extra performance impact for a spinning disc.
> > For flash, reading 128 sectors instead of the one requested will have a
> > noticeable performance impact.
> > Spinning discs have high seek latency, low serial sector read latency
> > and equal latency for read/write
> > Flash has low seek latency, high serial sector read latency and longer
> > write than read times.

A little bit of readahead will be helpful for flash memory.  Its latency is
low, but sure not zero. Asynchronous readahead will help to hide the latency.

> I was having problem invoking the readahead logic on my compact flash
> rootfs (ext3) with tweaking the RA with 'hdparm -a' from 8 to 1024
> blocks and some benchmarks (I forget which).
> 
> Fengguang, what is your favourite benchmark for finding differences in
> readahead values (running on eg ext3 on a flashdisk), with the current
> RA semantics in mainline kernels (eg 2.6.23-rc3)?

My favorite test cases are

big file:
        time cp $file /dev/null &>/dev/null
        time dd if=$file of=/dev/null \ bs=${bs:-4k} &>/dev/null

big file, parallel:
        time diff $file $file.clone

small files:
        time grep -qr 'doruimi' $dir 2>/dev/null

Don't forget to clear the cache before each run:
        echo 2 > /proc/sys/vm/drop_caches


Cheers,
Fengguang

