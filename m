Return-Path: <linux-kernel-owner+w=401wt.eu-S1750954AbXC3SYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750954AbXC3SYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbXC3SYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:24:19 -0400
Received: from aa014msr.fastwebnet.it ([85.18.95.74]:59082 "EHLO
	aa014msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbXC3SYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:24:18 -0400
Date: Fri, 30 Mar 2007 20:16:49 +0200
From: Mattia Dongili <malattia@linux.it>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix cpufreq_stats attrs removal
Message-ID: <20070330181649.GB4127@inferi.kami.home>
References: <20070319153013.GA6814@localhost.sw.ru> <20070319204125.GA5598@suse.de> <20070320100634.GA6811@localhost.sw.ru> <20070322030753.GB5728@suse.de> <20070322035104.GA17159@redhat.com> <20070322040006.GA6892@suse.de> <20070321201042.f1cbf4d8.akpm@linux-foundation.org> <20070322170201.GP4108@inferi.kami.home> <20070330080903.GA6559@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330080903.GA6559@localhost.sw.ru>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.21-rc5-mm3-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 12:09:03PM +0400, Alexey Dobriyan wrote:
> On Thu, Mar 22, 2007 at 06:02:01PM +0100, Mattia Dongili wrote:
> > On Wed, Mar 21, 2007 at 08:10:42PM -0800, Andrew Morton wrote:
> > > I ain't picky, but as a short-term thing it'd be kinda nice if it didn't
> > > oops the kernel.
> > 
> > There are other symptoms to this same bug:
> > 
> > 1. unload p4-clockmod: /sys/.../cpu0/cpufreq is removed all together
> > 2. load p4-clockmod: /sys/.../cpu0/cpufreq appears but no 'stats' subdir
> >    (yes, cpufreq_stats is loaded)
> > 3. rmmod cpufreq_stats: Ooops!
> > 
> > Call Trace:
> >  [<c0183f5b>] remove_dir+0x33/0xc4
> >  [<c0184fca>] remove_files+0x1a/0x28
> >  [<c018503b>] sysfs_remove_group+0x63/0x71
> >  [<f898c38d>] cpufreq_stat_cpu_callback+0x51/0x8a [cpufreq_stats]
> >  [<f898c477>] cpufreq_stats_exit+0x47/0x4b [cpufreq_stats]
> >  [<c012f145>] sys_delete_module+0x190/0x1b7
> >  [<c0140073>] do_wp_page+0x231/0x3e7
> >  [<c0102e17>] syscall_call+0x7/0xb
> > 
> > The problem is cpufreq_stats doesn't know when a cpufreq driver is
> > removed and doesn't cleanup. I guess this affects any setup with
> > cpufreq_stats.
> > The attached patch seems to solve both symptoms and yes... it's quite
> > invasive as it introduce one more cpufreq policy notification (REMOVED).
> > 
> > BTW: the patch is against .21-rc4-mm1 but applies with some fuzz to
> > 2.6.20 too
> 
> Also, it doesn't work.

hmmm... odd. I did test that case. Also, using .21-rc5-mm3 (which
has that patch applied) and acpi-cpufreq (I don't have that P4 handy
now) I actually hit a WARN_ON in kref_get(), but no oops:

# rmmod acpi-cpufreq

[ 1839.895632] acpi-cpufreq: acpi_cpufreq_exit
[ 1839.895637] cpufreq-core: unregistering driver acpi-cpufreq
[ 1839.895642] cpufreq-core: unregistering CPU 0
[ 1839.895649] cpufreq-core: __cpufreq_governor for CPU 0, event 2
[ 1839.895661] cpufreq-stats: removing tables
[ 1839.895714] cpufreq-core: last reference is dropped
[ 1839.895716] cpufreq-core: waiting for dropping of refcount
[ 1839.895718] cpufreq-core: wait complete
[ 1839.895720] acpi-cpufreq: acpi_cpufreq_cpu_exit
[ 1839.895723] freq-table: clearing show_table for cpu 0
[ 1839.895726] cpufreq-core: unregistering CPU 1
[ 1839.895728] cpufreq-core: __cpufreq_governor for CPU 1, event 2
[ 1839.895731] cpufreq-stats: removing tables    <------- dprintk on CPUFREQ_REMOVE
[ 1839.895741] cpufreq-core: last reference is dropped
[ 1839.895744] cpufreq-core: waiting for dropping of refcount
[ 1839.895746] cpufreq-core: wait complete
[ 1839.895747] acpi-cpufreq: acpi_cpufreq_cpu_exit
[ 1839.895749] freq-table: clearing show_table for cpu 1

# cat time_in_state

[ 1853.932509] BUG: at lib/kref.c:32 kref_get()
[ 1853.932567]  [<c0104b7a>] show_trace_log_lvl+0x1a/0x30
[ 1853.932676]  [<c0105705>] show_trace+0x12/0x14
[ 1853.932778]  [<c010575e>] dump_stack+0x16/0x18
[ 1853.932880]  [<c01dcfba>] kref_get+0x37/0x40
[ 1853.932986]  [<c01dc415>] kobject_get+0x15/0x1b
[ 1853.933087]  [<c019ff0b>] sysfs_open_file+0x40/0x209
[ 1853.933189]  [<c01693bc>] __dentry_open+0xc2/0x179
[ 1853.933293]  [<c01694f5>] nameidata_to_filp+0x27/0x38
[ 1853.933395]  [<c0169539>] do_filp_open+0x33/0x3b
[ 1853.933498]  [<c0169584>] do_sys_open+0x43/0xc7
[ 1853.933600]  [<c0169640>] sys_open+0x1c/0x1e
[ 1853.933700]  [<c0103d24>] sysenter_past_esp+0x5d/0x81
[ 1853.933799]  =======================
[ 1853.934330] cpufreq-core: last reference is dropped

-- 
mattia
:wq!
