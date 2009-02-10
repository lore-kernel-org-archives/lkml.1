Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbZBJNRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbZBJNRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZBJNRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:17:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52803 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbZBJNRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:17:31 -0500
Date: Tue, 10 Feb 2009 11:20:23 -0200
From: Glauber Costa <glommer@redhat.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       avi@redhat.com, akataria@vmware.com
Subject: Re: [PATCH 2/2] show hypervisor information on sysfs
Message-ID: <20090210132023.GB13577@poweredge.glommer>
References: <1233935217-24090-1-git-send-email-glommer@redhat.com> <1233935217-24090-2-git-send-email-glommer@redhat.com> <1233935217-24090-3-git-send-email-glommer@redhat.com> <20090207114331.49bb30bc@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090207114331.49bb30bc@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 11:43:31AM +0100, Heiko Carstens wrote:
> On Fri,  6 Feb 2009 10:46:57 -0500
> Glauber Costa <glommer@redhat.com> wrote:
> 
> > It is useful to easily grab information about whether or not
> > we're running on top of a hypervisor. And in case affirmative,
> > which one.
> > 
> > This patch shows it in /sys/hypervisor (and as a site effect, allow
> > it to be directly selectable).
> 
> Not really an objection, but is this really easily extensible? Next
> thing people are going to ask: how many cpus does my hypervisor have?
> Is my hypervisor running itself within a hypervisor and how many cpus
> does that have? etc.
> 
> Maybe some directory structure for each hypervisor level would be nice?
> 
> Just to get a feeling for what will come up next: on s390 we have the
> file /proc/sysinfo which contains a lot of information about all
> underlying hypervisors:
> 
> Manufacturer:         IBM             
> Type:                 2097
> Model:                724              E26             
> Sequence Code:        000000000003C03F
> Plant:                02  
> Model Capacity:       724              00001748
> Model Perm. Capacity: 724              00001748
> Model Temp. Capacity: 724              00001748
> 
> CPUs Total:           28
> CPUs Configured:      24
> CPUs Standby:         0
> CPUs Reserved:        4
> Capability:           904 1350
> Adjustment 02-way:    61500 61500
> Adjustment 03-way:    59260 59500
> Adjustment 04-way:    57480 57300
> Adjustment 05-way:    55800 55700
> Adjustment 06-way:    54700 54300
> Adjustment 07-way:    53600 53100
> Adjustment 08-way:    52500 52040
> Adjustment 09-way:    51200 51000
> Adjustment 10-way:    50100 50000
> Adjustment 11-way:    49000 49020
> Adjustment 12-way:    48000 48120
> Adjustment 13-way:    47200 47300
> Adjustment 14-way:    46400 46500
> Adjustment 15-way:    45600 45800
> Adjustment 16-way:    44800 45200
> Adjustment 17-way:    44300 44680
> Adjustment 18-way:    43900 44120
> Adjustment 19-way:    43500 43640
> Adjustment 20-way:    43100 43200
> Adjustment 21-way:    42600 42740
> Adjustment 22-way:    42300 42360
> Adjustment 23-way:    42000 41980
> Adjustment 24-way:    41700 41600
> Adjustment 25-way:    41400 41240
> Adjustment 26-way:    41100 40960
> Adjustment 27-way:    40800 40680
> Adjustment 28-way:    40400 40360
> Secondary Capability: 904
> 
> LPAR Number:          47
> LPAR Characteristics: Shared 
> LPAR Name:            H42LP45 
> LPAR Adjustment:      500
> LPAR CPUs Total:      16
> LPAR CPUs Configured: 12
> LPAR CPUs Standby:    4
> LPAR CPUs Reserved:   0
> LPAR CPUs Dedicated:  0
> LPAR CPUs Shared:     12
> 
> VM00 Name:            H4245004
> VM00 Control Program: z/VM    5.3.0   
> VM00 Adjustment:      250
> VM00 CPUs Total:      3
> VM00 CPUs Configured: 3
> VM00 CPUs Standby:    0
> VM00 CPUs Reserved:   0
> 
> Besides a lot of other stuff this tells you that my guest is running on
> 28 cpu machine (24 cpus active), that my guest is running in logical
> partition 47, which has 16 cpus of which 12 are used. Within that
> logical partition my hypervisor is running (z/VM 5.3.0). And finally it
> tells you my guest (H4245004) has three cpus (cpus that you're going to
> see in /proc/cpuinfo).
> 
> Oh, and before somebody asks: yes, we do have an instruction to get all
> of this information ;)
errr... I imagined you did.
s390 is the closest architecture to get a dwiw instruction in the planet.

> 
> Anyway, just wanted to make you aware of what might come next.

Why wouldn't it be extensible? So far, I've only added an attribute. But we
can easily add others, and directories with even more attributes if we must.

> why not simply:
> 
> 	return sysfs_create_file(hypervisor_kobj, &hyper_name_attr.attr);
> 
> If it fails the sysfs code hopefully will dump something on the
> console. We shouldn't add a printk for each and every sysfs_create_file
> that might fail. It's just overkill.

agreed.

