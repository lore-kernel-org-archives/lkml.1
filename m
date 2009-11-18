Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbZKRVLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbZKRVLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbZKRVLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:11:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933AbZKRVLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:11:42 -0500
Subject: Re: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
From: Eric Paris <eparis@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, graff.yang@gmail.com,
       linux-kernel@vger.kernel.org, gyang@blackfin.uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graf.yang@analog.com>,
       linux-security-module@vger.kernel.org
In-Reply-To: <20091117141314.0238a49b.akpm@linux-foundation.org>
References: <1255706463.15182.84.camel@dhcp231-106.rdu.redhat.com>
	 <7e0fb38c0910160801o50346a5cm763d79cab98272a5@mail.gmail.com>
	 <1255516134-4838-1-git-send-email-graff.yang@gmail.com>
	 <18475.1255529305@redhat.com> <6207.1255706090@redhat.com>
	 <23382.1255707790@redhat.com>
	 <1255708529.15182.95.camel@dhcp231-106.rdu.redhat.com>
	 <20091117141314.0238a49b.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 16:10:14 -0500
Message-Id: <1258578614.3534.2.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 14:13 -0800, Andrew Morton wrote:
> On Fri, 16 Oct 2009 11:55:29 -0400
> Eric Paris <eparis@redhat.com> wrote:
> 
> > On Fri, 2009-10-16 at 16:43 +0100, David Howells wrote:
> > > Eric Paris <eparis@redhat.com> wrote:
> > > 
> > > > That would still call cap_file_mmap() and wouldn't solve your problem.
> > > 
> > > Hmmm...  I guess I don't see the problem occur because I always run the
> > > programs as root.
> > 
> > most likely yes, your processes are going to have CAP_SYS_RAWIO and will
> > happily sail through the cap_file_mmap().
> > 
> > > I would guess that cap_file_mmap() and selinux_file_mmap() are, perhaps, too
> > > strict.  The hint shouldn't be rejected unless MAP_FIXED is also set, surely,
> > > but should rather be revised upwards.
> > 
> > On the mmu side we don't check until the kernel has turned the hint into
> > a real address.  Which is apparently different then where the hook was
> > originally placed in the nommu side.
> > 
> > > Certainly, addr==NULL and !MAP_FIXED is a reasonable case to permit, even in
> > > tightly secured MMU and SELinux mode...  After all, the manual page says:
> > > 
> > > 	If addr is NULL, then the kernel chooses the address at which to create
> > > 	the mapping; this is the most portable method of creating  a  new  map-
> > > 	ping.
> > 
> > I agree, I think the choices are
> > 
> > A) agree that we just shouldn't check the address on nommu
> >    A1) change kconfig to not allow the setting of these
> > 	(easy to do for the LSM check, but not easy as it stands today
> > 	 for the cap_file_mmap() check)
> >    A2) change the addr_only to be a flags which indicate not to check
> > 	(my original suggestion)
> >    A3) push the config_nommu down into the security code
> > 	(your patch)
> > B) actually check the address, which requires moving the hook to a
> > location where it has been resolved.
> > 	(graff yang's patch)
> > 
> > I'll leave it up to you to determine which you like the best since you
> > know the implications of nommu.
> > 
> 
> So what's the status of this issue now?  Should I merge the below into
> 2.6.32?
> 
> Thanks.

David??
  I think A2 is the right fix.  Apparmour is pushing to get in soon and
I know their implementation didn't check for CONFIG_MMU.  It's just too
easy for an LSM writer to get this wrong.  This patch is better than
what we have today, but I'll try to get something by the end of the week
which I think makes us all happy.

-Eric

