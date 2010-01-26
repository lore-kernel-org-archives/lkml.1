Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416Ab0AZVGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0AZVGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617Ab0AZVF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:05:59 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:36986 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab0AZVF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:05:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=xSgWo4jp2i07QAyr0sX3WO1By2LJfq6HFLw1vK4baOYTxPfYdpd24ECYr1ldrBuFYL
         Nkunaf1h2JtN41/g6CmSZMwIRHPG5cVpiBHYoCUVK+I7dcolGlrJUqnBvOUJ3PBP1U66
         Xe1wfv6CsDC+sqs/l1l3bFG5VrX02K29pYmSk=
Date: Tue, 26 Jan 2010 19:05:52 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: john smith <whalajam@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: perf report for .ko files
Message-ID: <20100126210552.GA12567@ghostprotocols.net>
References: <666103.59126.qm@web55005.mail.re4.yahoo.com>
 <1264533715.4283.1961.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264533715.4283.1961.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 26, 2010 at 08:21:55PM +0100, Peter Zijlstra escreveu:
> On Mon, 2010-01-25 at 16:34 -0800, john smith wrote:
> > How can "perf report" be used to get info on (only) the specific manually loadable modules?
> > Driver entry points are reported but without full breakdown (on all the calls).
> 
> Since its sampling it could be a function is just not hit, another
> possibility is inlining of functions, we simply cannot see inlined
> functions.

Well, you could reduce the number of samples collected by asking perf record to
include only kernel samples by fiddling with these perf_event_attr fields:

     exclude_user   :  1, /* don't count user      */
     exclude_kernel :  1, /* ditto kernel          */
     exclude_hv     :  1, /* ditto hypervisor      */
     exclude_idle   :  1, /* don't count when idle */

I.e. setting exclude_user, exclude_hv and exclude_idle to 1, but this requires
a patch for tools/perf/builtin-record.c as this is not exposed yet.

Something similar to what we have in 'perf top'

    -K, --hide_kernel_symbols
                          hide kernel symbols
    -U, --hide_user_symbols
                          hide user symbols

And then increase the frequency.
 
> > If "--symbols" option is used, most of the symbols are not found.
> > ("--dsos" doesn't seem to help)
> 
> I'm not a big module user, but I think --dsos should work, if not feel
> free to send a patch to rectify this situation.

--dsos does work for kernel modules, yes:

[root@doppio linux-2.6-tip]# perf report --dsos '[e1000e]'
# dso: [e1000e]
# Samples: 110518812
#
# Overhead          Command  Symbol
# ........  ...............  ......
#
    22.98%             init  [k] e1000_clean
    21.52%             mutt  [k] e1000_clean
    17.95%             mutt  [k] e1000_intr_msi
    16.60%             init  [k] e1000_intr_msi
    11.82%         events/0  [k] e1000e_update_stats
     1.80%             mutt  [k] e1000_put_txbuf
     1.79%             mutt  [k] e1000_clean_tx_irq
     1.28%             init  [k] e1000_clean_tx_irq
     1.14%             init  [k] e1000_clean_rx_irq
     1.02%             sshd  [k] e1000_xmit_frame
     0.52%             init  [k] pci_unmap_single
     0.43%          openvpn  [k] e1000_xmit_frame
     0.29%             sshd  [k] e1000_intr_msi
     0.18%             init  [k] e1000_update_itr
     0.15%             sshd  [k] pci_dma_mapping_error
     0.15%             init  [k] pci_dma_mapping_error
     0.14%             init  [k] e1000_alloc_rx_buffers
     0.13%             sshd  [k] e1000_clean
     0.11%             init  [k] e1000_rx_checksum
#
# (For a higher level overview, try: perf report --sort comm,dso)
#
[root@doppio linux-2.6-tip]#
 
> --dsos does appear to work on my laptop (where I have iwlagn as a module
> since it sometimes needs a reload to start working, which is hard when
> build in).
> 
> perf report --dsos "[iwlagn]"

yup, exactly like my example above.
 
> does indeed give me all iwlagn hits, albeit without symbol information,
> not sure why that is, /proc/kallsyms does seem to include some iwlagn
> symbols.

but not all, in verbose mode we can see from where it gets the module
symbol information:

[root@doppio linux-2.6-tip]# perf report --verbose --dsos '[e1000e]' |
head -10
Looking at the vmlinux_path (5 entries long)
No build_id in vmlinux, ignoring it
No build_id in /boot/vmlinux, ignoring it
No build_id in /boot/vmlinux-2.6.33-rc5-tip+, ignoring it
Using /lib/modules/2.6.33-rc5-tip+/build/vmlinux for symbols
# dso: [e1000e]
# Samples: 110518812
#
# Overhead          Command  Symbol
# ........  ...............  ......
#
    22.98%             init  0x000000000001088c B [k] e1000_clean
    21.52%             mutt  0x000000000001088c B [k] e1000_clean
    17.95%             mutt  0x000000000000db5c B [k] e1000_intr_msi
    16.60%             init  0x000000000000db5c B [k] e1000_intr_msi
[root@doppio linux-2.6-tip]#

In my case, all came from the buildid-cache, the ' B ' above:

from tools/perf/util/symbol.c (should be in the man page, consider
submitting a patch for that :)):

char dso__symtab_origin(const struct dso *self)
{
        static const char origin[] = {
                [DSO__ORIG_KERNEL] =   'k',
                [DSO__ORIG_JAVA_JIT] = 'j',
                [DSO__ORIG_BUILD_ID_CACHE] = 'B',
                [DSO__ORIG_FEDORA] =   'f',
                [DSO__ORIG_UBUNTU] =   'u',
                [DSO__ORIG_BUILDID] =  'b',
                [DSO__ORIG_DSO] =      'd',
                [DSO__ORIG_KMODULE] =  'K',
        };

        if (self == NULL || self->origin == DSO__ORIG_NOT_FOUND)
                return '!';
        return origin[self->origin];
}

For further info:

Use 'perf buildid-list' to get the build-id for the kernel module used at 'perf
record' time.

[root@doppio linux-2.6-tip]# perf buildid-list | grep e1000e
05c45e33bc92bf4bbc71ddde4128a9f5f1463fcb /lib/modules/2.6.33-rc5-tip+/kernel/drivers/net/e1000e/e1000e.ko

Then look it up in the build-id cache:

[root@doppio linux-2.6-tip]# l ~/.debug/.build-id/05/c45e33bc92bf4bbc71ddde4128a9f5f1463fcb
lrwxrwxrwx 1 root root 110 2010-01-22 12:12 /root/.debug/.build-id/05/c45e33bc92bf4bbc71ddde4128a9f5f1463fcb -> ../../lib/modules/2.6.33-rc5-tip+/kernel/drivers/net/e1000e/e1000e.ko/05c45e33bc92bf4bbc71ddde4128a9f5f1463fcb
[root@doppio linux-2.6-tip]#

So indeed, at 'perf record' time we found that the file that matched the loaded
e1000e.ko file was:

/lib/modules/2.6.33-rc5-tip+/kernel/drivers/net/e1000e/e1000e.ko

by looking at its build-id ELF note and at:

/sys/module/e1000e/sections/.note.gnu.build-id

for the build-id  in the e1000e.ko loaded at that time. 

> Arnaldo might have a clue.

See above :-)

- Arnaldo
