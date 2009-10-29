Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbZJ2Q1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbZJ2Q1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbZJ2Q1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:27:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832AbZJ2Q1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:27:04 -0400
Message-ID: <4AE9C29E.6090706@suse.de>
Date: Thu, 29 Oct 2009 17:28:14 +0100
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/3] Sysfs: Allow directories to be populated	dynamically
References: <20091020054740.GC29158@parisc-linux.org> <20091020055021.GE29158@parisc-linux.org> <4AE9C0B0.3030304@suse.de> <20091029162145.GM10555@parisc-linux.org>
In-Reply-To: <20091029162145.GM10555@parisc-linux.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Oct 29, 2009 at 05:20:00PM +0100, Tejun Heo wrote:
>> This will increase the size of struct sysfs_dirent by three pointers
>> which is considerable.  Bloating the size of sysfs_dirent can waste
>> large amount of memory on machines with a lot of disks.
> 
> No it won't.  It's in a union with sysfs_inode_attrs which contains a
> struct iattr, which is at least 52 bytes.

 struct sysfs_dirent {
	 atomic_t		s_count;
	 atomic_t		s_active;
	 struct sysfs_dirent	*s_parent;
	 struct sysfs_dirent	*s_sibling;
	 const char		*s_name;

	 union {
		 struct sysfs_elem_dir		s_dir;
		 struct sysfs_elem_symlink	s_symlink;
		 struct sysfs_elem_attr		s_attr;
		 struct sysfs_elem_bin_attr	s_bin_attr;
	 };

	 unsigned int		s_flags;
	 ino_t			s_ino;
	 umode_t			s_mode;
	 struct sysfs_inode_attrs *s_iattr;
	                          ^^
 };

>> The implementation looks quite scary to me.  Is this the only way to
>> do this?  It it because trying to create individual entries for msix
>> will end up creating too many sysfs entries?  If so, how many are we
>> talking about?
> 
> While that's the original motivation, shrinking the amount of memory
> taken by sysfs overall is a worthwhile achievement, don't you think?

It feels a bit too convoluted to me.  sysfs is already pretty
convoluted and adding yet more convolution would require pretty good
justification, so I'm curious about the numbers.

Thanks.

-- 
tejun
