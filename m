Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbZENSDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbZENSDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 14:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbZENSDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 14:03:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48886 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbZENSDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 14:03:42 -0400
Date: Thu, 14 May 2009 14:02:34 -0400
From: Josef Bacik <josef@redhat.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Josef Bacik <josef@redhat.com>, sandeen@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] sys_write() should write all valid data
Message-ID: <20090514180234.GB10059@dhcp231-156.rdu.redhat.com>
References: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 06:18:59PM +0200, Vitaly Mayatskikh wrote:
> There's user-visible misbehavour in sys_write(): when user tries to put
> down to disk some data, which crosses boundary of existing memory, sys_write()
> either immediately returns with EFAULT or writes first page(s).
> 
> Next 2 patches make sys_write()'s behaviour more consistent: it tries now
> to write down all what it can.
> 
> Vitaly Mayatskikh (2):
>   Introduce check_readable_bytes()
>   Perform checks in iov_iter_fault_in_readable() with
>     check_readable_bytes()
> 
>  fs/fuse/file.c          |    6 ++++--
>  include/linux/pagemap.h |   35 +++++++++++++++++++++++++++++++++++
>  mm/filemap.c            |   13 +++++++++----
>  3 files changed, 48 insertions(+), 6 deletions(-)
>

Ok all in all I don't think this is a good way to handle this problem.
Hopefully somebody smarter than I will speak up, but what you are trying to do
here is have your cake and eat it too.  You want to get the size of what we were
able to fault in and return that, which should be a size_t, but you also want to
throw back an error if something happened, which needs a signed value.  I think
the best way to handle this would be to make check_readable_bytes return size_t,
and then if you get an EFAULT back, have it return 0.  Then the caller can say
"hey I couldn't fault anything in, let me make what I want to fault in smaller",
and then if that fault returns 0 we can exit.  I hope thats helpful/correct :).
Thanks,

Josef
