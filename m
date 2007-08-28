Return-Path: <linux-kernel-owner+w=401wt.eu-S1759887AbXH1AKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbXH1AKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 20:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbXH1AKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 20:10:09 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:33619 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751092AbXH1AKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 20:10:08 -0400
Message-ID: <388259805.10631@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 28 Aug 2007 08:10:04 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to find out how many other processes share VM with $PID?
Message-ID: <20070828001004.GA11875@mail.ustc.edu.cn>
References: <200708271256.31874.vda.linux@googlemail.com> <388216835.20155@ustc.edu.cn> <200708271426.50675.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708271426.50675.vda.linux@googlemail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 02:26:50PM +0100, Denys Vlasenko wrote:
> On Monday 27 August 2007 13:13, Fengguang Wu wrote:
> > Hi Denys,
> >
> > On Mon, Aug 27, 2007 at 12:56:31PM +0100, Denys Vlasenko wrote:
> > > Hi,
> > >
> > > I was a bit frustrated by bad quality of memory usage info
> > > from top and ps, and decided to write my own utility.
> > >
> > > One problem I don't know how to solve is how to avoid counting
> > > twice (or more) memory used by processes which share VM
> > > (by use of CLONE_VM flage to sys_clone).
> > >
> > > I know how to detect and correctly account for threads
> > > (processes created with CLONE_THREAD), but how to detect non-threads
> > > with shared VM?
> >
> > There is a nice LWN article on this issue:
> >         ELC: How much memory are applications really using?
> >         http://lwn.net/Articles/230975/
> >
> > Another helpful patch could be:
> >         maps: PSS(proportional set size) accounting in smaps
> >         http://lkml.org/lkml/2007/8/19/23
> 
> Thanks a lot, very useful pages indeed.
> 
> However they still don't explain how I can avoid counting memory
> twice for /proc/PID1 and /proc/PID2 when PID2 is a child of PID1,
> created with CLONE_VM.
> 
> The example: I allocate 1234k, dirty it, then clone with CLONE_VM.
> I will seemingly have two processes, each using 1234k, _privately_
> (i.e., pages are not shown as shared in smaps) -
> which is technically correct, pages are not shared with other VMs,
> but they ARE shared by means of these two processes having the same VM!
> 
> How userspace tools can figure out that these processes have shared VM?
> 
> IOW: do we need "VMsharecount: N" in addition to "Threads: N"
> in /proc/PID/status?

A full solution would require two parameters, i.e. VmUsers/VmMagic.

But please make sure the new lines won't break important tools like
ps/top/pmaps/...

A quick test shows that only ps will parse /proc/<pid>/status:

        strace -e open ps
        strace -e open top
        strace -e open pmap $$

