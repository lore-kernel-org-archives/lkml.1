Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbYCNRAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbYCNRAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 13:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbYCNQ7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 12:59:44 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:3193 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752450AbYCNQ7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 12:59:42 -0400
X-SourceIP: 77.248.44.122
Date: Fri, 14 Mar 2008 18:00:04 +0100
From: Carlo Wood <carlo@alinoe.com>
To: ext3grep@googlegroups.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ext3grep] compile error
Message-ID: <20080314170004.GA25174@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>, ext3grep@googlegroups.com,
	linux-kernel@vger.kernel.org
References: <1f45affd0803140826m34d9eee5veb8069e215d55fcf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f45affd0803140826m34d9eee5veb8069e215d55fcf@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 08:56:40PM +0530, vishwanathtk@gmail.com wrote:
> Hi,
> 
> I am getting some compile time error:
> 
> make[2]: Entering directory `/usr/src/redhat/BUILD/ext3grep-0.0.1/src'
> g++ -Iempty.pch.h -DHAVE_CONFIG_H -I. -I..    -g -O2  -include pch.h \
>           -c -o pch.h.gch/68b329da9893e34099c7d8ad5cb9c940 ./pch-source.h
> /usr/include/linux/ext3_fs.h: In function 'unsigned int ext3_rec_len_from_disk (__le16)':
> /usr/include/linux/ext3_fs.h:615: error: 'le16_to_cpu' was not declared in this scope

This seem a bug in linux/ext3_fs.h. I was able to reproduce this on
debian sid, meaning kernel (headers) 2.6.24.

linux/ext3_fs.h defines functions in user space (with __KERNEL__
UNdefined) that use le16_to_cpu et al, but those are not defined
without __KERNEL__ being defined. Moreover, the header that defined
them is no longer available in userspace.

This means that we'd need an ugly work around: you'll have to
define all those macro's yourself before including linux/ext3_fs.h.
The best thing to do is to add a test to configure.ac for this,
and when needed define the macro's in sys.h.

linux/ext3_fs.h is now also using/calling a macro called BUG(), wtf?

Is there a kernel hacker on the list who can tell me what to do?
Is is not allowed to include <linux/ext3_fs.h> (and <linux/jbd.h>)
in a user application? How is one supposed to use these header files?

I can write workarounds without problems, but that might break every
other kernel version if things like this are being done.

I'm also getting:

/usr/include/linux/jbd.h:63: error: 'get_order' was not declared in this scope
/usr/include/linux/jbd.h:63: error: '__get_free_pages' was not declared in this scope
/usr/include/linux/jbd.h:68: error: 'free_pages' was not declared in this scope

-- 
Carlo Wood <carlo@alinoe.com>
