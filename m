Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbXFKGrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbXFKGrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 02:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbXFKGqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 02:46:55 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:36396
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbXFKGqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 02:46:54 -0400
Date: Sun, 10 Jun 2007 23:45:16 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Crispin Cowan <crispin@novell.com>
cc: casey@schaufler-ca.com, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <466C6451.6030907@novell.com>
Message-ID: <Pine.LNX.4.64.0706102328200.6675@asgard.lang.hm>
References: <700465.32295.qm@web36612.mail.mud.yahoo.com> <466C6451.6030907@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2007, Crispin Cowan wrote:

> Casey Schaufler wrote:
>> --- david@lang.hm wrote:
>>
>>>> Yes, and in the process, AA stores compiled regular expressions in
>>>> kernel. Ouch. I'll take "each file it's own label" over _that_ any time.
>>>>
>>> and if each file has it's own label you are going to need regex or similar
>>> to deal with them as well.
>>>
>> Now that you're going to have to explain. Nothing like that
>> on any of the MLS systems I'm familiar with, and I think that
>> I know just about all of them.
>>
> I suspect that David meant that if you were using "unique label per
> file" as an implementation technique to implement AA on top of SELinux,
> that you would then need a regexp to discern labels.

exactly.

say that we give each file a unique label, and for simplicity we set the 
label == path (note that this raises the issue, what will SELinux do when 
there are multiple paths to the same file)

now say that you want to grant apache access to all files that have labels 
that follow the pattern '/home/*/http/* ?

you are either going to use regex matching, or you are going to have to 
enumerate every label that matches this (potentially a very large list). 
and if you try to generate the enumerated list you need to add a label to 
the list if a file is renamed or created to match the pattern, and delete 
a file from the list if it is renamed to no longer match the pattern

> It's hard to recall with all the noise, but at this point in the thread
> the discussion is about the best way to implement AA. Some have alleged
> that AA layered on top of SELinux is the best way. I think that is
> clearly wrong; AA layered on top of SELinux is possible, but would
> require a bunch of enhancements to SELinux first, and the result would
> be more complex than the proposed AA patch and have weaker functionality
> and performance.

AA as-is needs to figure out how to deal with bind-mounts, and how to 
handle hardlink creation in a more ganular manner (and potentially other 
resources like network sockets), but it's useful now even without these 
improvements


AA over SELinux would need for SELinux to figure out how to handle file 
creation, file renames, and multiple paths for the same file (hard-links 
and bind-mounts). In addition a userspace daemon would have to be written 
to re-label files and/or change policy on the fly as files are renamed. 
the result would still have race conditions due to the need to re-label 
large numbers of files


ACPI should have taught everyone that sometimes putting an interpreter in 
the kernel really is the best option. looking at the problems of bouncing 
back out to userspace for file creation and renames it looks like a regex 
in the kernel is a lot safer and more reliable.

David Lang
