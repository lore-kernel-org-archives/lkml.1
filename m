Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbYDNNQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbYDNNQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYDNNPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:15:51 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:33091 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbYDNNPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:15:50 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>
In-Reply-To: <Pine.LNX.4.62.0804141444320.22065@tamago.serverit.net>
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
References: <14725485.776281208170999085.JavaMail.szaka@kolumbus.fi> <Pine.LNX.4.62.0804141444320.22065@tamago.serverit.net>
Message-Id: <38B7FCFD-9F4F-4D03-9FEE-E44EA19D1599@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Mon, 14 Apr 2008 14:15:39 +0100
Cc: Miklos Szeredi <miklos@szeredi.hu>, dwmw2@infradead.org, hch@infradead.org,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 14 Apr 2008, at 13:46, Szabolcs Szakacsits wrote:
>
> On Mon, 14 Apr 2008 Anton Altaparmakov wrote:
>> On 14 Apr 2008, at 08:49, Andrew Morton wrote:
>>> On Mon, 14 Apr 2008 09:25:46 +0200 Miklos Szeredi  <miklos@szeredi.hu 
>>> >
>>> wrote:
>>>
>>>> And I didn't advocate moving
>>>> ntfs to fuse, still that was done and the resulting filesystem at  
>>>> the
>>>> moment happens to outperform the kernel one in every respect ;)
>>>
>>> Gad.  Why?
>
> Well, not only the kernel ntfs (in metadata operations) but also  
> XFS, JFS,
> ext2 in metadata operations, ext3 in large bulk writes on commodity
> hardware.
>
> It's also important to note that ntfs-3g isn't optimized yet at all.  
> There
> are several major performance bootlenecks still in the kernel, FUSE  
> and
> ntfs-3g itself.
>
> Answering the why, the issue is almost never the context switch but  
> the
> file system design and the quality of the implementation. While the  
> latter
> still needs a lot of work on several areas (the size of the  
> Microsoft NTFS
> driver is almost like all the in-kernel file system altogether) but  
> the
> design can very nicely compensate the latter. E.g. ntfs (and ntfs-3g)
> already supports almost all the things what ext4 will include.
>
>> No-one has "moved" ntfs to fuse.
>
> Yes, historically the user space ntfs code was moved to the kernel.  
> The
> kernel always lagged somehow behind when this work was stopped a few  
> years
> ago.

Yes.  It was much easier for me to write the ntfs code for user space  
in ntfsprogs/libntfs and then once I had the ntfs side of it working  
reliably port it to the kernel so I then only had to deal with kernel  
interface/threading/etc issues but at least the NTFS code would be  
there.  Over time this changed for me and I started working primarily  
on the kernel and pushing things back into libntfs and as these things  
go I eventually was so busy that I no longer had the time to do any  
back porting to libntfs and since then I have only been working on the  
kernel driver.  Unfortunately I haven't been allowed to release my  
work yet as it is used in a closed source production environment but  
hopefully one day I will be allowed to release it and update the  
kernel driver with my code which will move it up to being a fully  
function read-write driver.  Or if I never end up being able to do  
that then things are not too bad either as my MacOSX NTFS driver  
(Leopard already has the read-only driver in it) will eventually be  
released and that is BSD/GPL dual licensed so anyone will be able to  
take the source and port it to Linux thus cutting me out of the loop...

>> However the kernel one as available in the kernel source tree doesn't
>> have many write-features, it can only overwrite files, it cannot
>> create/delete files, etc.  So I guess if you define "performance"  
>> to mean
>> "features" then sure ntfsmount/ntfs-3g have more features than the  
>> public
>> kernel driver.  If you define "performance" to mean "speed" then no
>> ntfsmount/ntfs-3g can't compare to the kernel except in very  
>> limited and
>> meaningless benchmarks...
>
> First comes reliability for ntfs-3g. There are just too many million  
> users.
> This is non-negotiable. Because of this, ntfs-3g is indeed not  
> optimized
> yet.
>
> However the bootlenecks are almost always storage related (seeks,
> bandwidth, buses) on commodity desktop systems. Embedded devices and
> servers come a bit later with the CPU usage optimizations.
>
>> btw. even comparing features, the fuse solutions lag behind in  
>> some  respects,
>> e.g. no-one can "kill -9" the kernel driver
>
> I consider this as a benefit for FUSE file systems. An unloadable  
> kernel
> module results reboot which is much more intrusive.

Kernel modules don't become "unloadable" unless there is a bug.  The  
"kill -9" can happen inadvertently even without any bugs in the FUSE  
or the FUSE-fs.  And that IMO is unacceptable.

>> leaving a corrupt file system on the volume
>
> That would be a file system driver implementation bug. What I never  
> denied
> for ntfs-3g. Surely it's solvable but this was never a priority  
> based on
> user wishes.
>
>> (and under no-one I include the OOM killer for example!)
>
> The OOM killer can be configured and if the fs still uses too much  
> memory
> then probably it's better to be killed/restarted with journaling  
> support.
> The important here would be the kernel finally fixing the non-sync  
> behavior
> when it clams to do so (see recent kernel threads).

You don't get the point.  Any process in the system can be using too  
much memory and trigger the OOM killer even when the FS is behaving  
just fine...

> On the other hand, when in-kernel drivers leak then you get a system
> panic.

So don't leak then!  (-;

>> and another example is that the fuse solutions require large  
>> amounts of
>> ram whereas the kernel driver can happily function in 1MiB ram
>
> A FUSE driver can also happily function in much less than 1 MB RAM.

Obviously it can!  We use a FUSE based file system I wrote here at the  
University on about 850 machines and it doesn't use any RAM at all  
(well, ok a few kiB but that is hardly worth talking about!).

>> when they find a large directory and the user has only 32MiB ram for
>> example...
>
> This is a FUSE fs implementation, not FUSE problem.

I never said it was a FUSE problem!  It is a ntfsmount/ntfs-3g  
problem.  At least a few years ago someone was trying to use ntfsmount  
(or ntfs-3g I can't remember if you had already forked it then) on a  
32MiB RAM embedded ARM box and he was running OOM when trying to list  
directories due to the ntfs/fuse implementation.  In the kernel ntfs  
driver that does not happen.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

