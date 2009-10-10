Return-Path: <linux-kernel-owner+w=401wt.eu-S934682AbZJJAvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934682AbZJJAvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 20:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbZJJAvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 20:51:54 -0400
Received: from claw.goop.org ([74.207.240.146]:54707 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbZJJAvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 20:51:53 -0400
Message-ID: <4ACFD43E.6000506@goop.org>
Date: Fri, 09 Oct 2009 17:24:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Zach Brown <zach.brown@oracle.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall implementation
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com> <4ACB0833.2050203@redhat.com> <4ACB9074.1000804@goop.org> <4ACC6C9C.7080707@redhat.com>
In-Reply-To: <4ACC6C9C.7080707@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/09 03:25, Avi Kivity wrote:
> def try_pvclock_vtime():
>   tsc, p0 = rdtscp()
>   v0 = pvclock[p0].version
>   tsc, p = rdtscp()
>   t = pvclock_time(pvclock[p], tsc)
>   if p != p0 or pvclock[p].version != v0:
>      raise Exception("Processor or timebased change under our feet")
>   return t

This doesn't quite work.

If we end up migrating some time after the first rdtscp, then the
accesses to pvclock[] will be cross-cpu.  Since we don't made any strong
SMP memory ordering guarantees on updating the structure, the snapshot
isn't guaranteed to be consistent even if we re-check the version at the
end.

So to use rdtscp we need to either redefine the update of
pvclock_vcpu_time_info to be SMP-safe, or keep the additional migration
check.

    J
