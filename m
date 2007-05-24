Return-Path: <linux-kernel-owner+w=401wt.eu-S1763968AbXEXEVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763968AbXEXEVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 00:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759685AbXEXEVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 00:21:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:44621 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759915AbXEXEVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 00:21:43 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Nico Golde <nico@ngolde.de>
Subject: Re: maximum count of thermal zones and fans in acpi?
Date: Thu, 24 May 2007 00:20:19 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070523170702.GA9169@ngolde.de>
In-Reply-To: <20070523170702.GA9169@ngolde.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705240020.19925.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 May 2007 13:07, Nico Golde wrote:
> Hi,
> I am currently implementing a general purpose shared library 
> for acpi focused on all the tools giving acpi information 
> like battery, thermal zones, fans, etc.

Note that /proc/acpi is going away in the long term.

The ideal is that things that are implemented via ACPI
should instead appear as generic features under sysfs
when possible.

There will still be some ACPI-specific things stuffed
into /sys/firmware/acpi -- but not the kind of useful-
to-the-user stuff that you are looking for.

> Since I was not able to find anything about it in the acpi 
> specs[0] (of course I didn't read every single page though)
> and with a quick look into the kernel sources I wondered if 
> there is a maximum count for thermal zones and fans in the 
> acpi implementation of the kernel.
> 
> Every acpi module just calls proc_mkdir for example:
>        acpi_device_dir(device) = proc_mkdir(acpi_device_bid(device),
>                                             acpi_thermal_dir);
> 
> struct proc_dir_entry *proc_mkdir_mode(const char *name, mode_t mode,
>                 struct proc_dir_entry *parent)
> {
>         struct proc_dir_entry *ent;
> 
>         ent = proc_create(&parent, name, S_IFDIR | mode, 2);

And this is a systematic bug in the ACPI code.
The "name" should _never_ be exposed to user-space.
Eg. all the names under, say /proc/acpi/*/*
are arbitrary strings created by the BIOS programmer.

They are meaningless to the user, except that they
are unique.  To answer your question, there is no limit
to instances of ACPI objects, such as the number of thermal zones.

cheers,
-Len

>         if (ent) {
>                 ent->proc_fops = &proc_dir_operations;
>                 ent->proc_iops = &proc_dir_inode_operations;
> 
>                 if (proc_register(parent, ent) < 0) {
>                         kfree(ent);
>                         ent = NULL;
>                 }
>         }
>         return ent;
> }
> 
> struct proc_dir_entry *proc_mkdir(const char *name,
>                 struct proc_dir_entry *parent)
> {
>         return proc_mkdir_mode(name, S_IRUGO | S_IXUGO, parent);
> }
> 
> 
> So is there no check for any max item count here?
> 
> I ask because I need to decide whether I want to allocate space for every
> acpi object or to use a fixed size array for them depending on the maximum
> item (where item is one device) count.
> 
> [0]: http://www.acpi.info/spec.htm
> 
> Kind regards
> Nico
> P.S. Please Cc me I am not subscribed
> 
