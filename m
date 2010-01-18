Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146Ab0ARASu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab0ARASu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246Ab0ARASt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:18:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55843 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab0ARASs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:18:48 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 18 Jan 2010 09:15:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Eric Paris <eparis@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       David Howells <dhowells@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
       <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 6/6] vfs: introduce FMODE_NEG_OFFSET for allowing
 negative f_pos
Message-Id: <20100118091527.7a0e2c6e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <87bpgurz00.fsf@devron.myhome.or.jp>
References: <20100115013954.311049665@intel.com>
	<20100115014422.959401729@intel.com>
	<87bpgurz00.fsf@devron.myhome.or.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jan 2010 21:54:39 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Wu Fengguang <fengguang.wu@intel.com> writes:
> 
> > +static int
> > +__negative_fpos_check(struct file *file, loff_t pos, size_t count)
> > +{
> > +	/*
> > +	 * pos or pos+count is negative here, check overflow.
> > +	 * too big "count" will be caught in rw_verify_area().
> > +	 */
> > +	if ((pos < 0) && (pos + count < pos))
> > +		return -EOVERFLOW;
> > +	if (file->f_mode & FMODE_NEG_OFFSET)
> > +		return 0;
> > +	return -EINVAL;
> > +}
> > +
> >  /*
> >   * rw_verify_area doesn't like huge counts. We limit
> >   * them to something that fits in "int" so that others
> > @@ -222,8 +236,11 @@ int rw_verify_area(int read_write, struc
> >  	if (unlikely((ssize_t) count < 0))
> >  		return retval;
> >  	pos = *ppos;
> > -	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
> > -		return retval;
> > +	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0)) {
> > +		retval = __negative_fpos_check(file, pos, count);
> > +		if (retval)
> > +			return retval;
> > +	}
> >  
> >  	if (unlikely(inode->i_flock && mandatory_lock(inode))) {
> >  		retval = locks_mandatory_area(
> 
> Um... How do lseek() work? It sounds like to violate error code range.

This is for read-write. As far as I know, 
  - generic_file_llseek,
  - default_llseek
  - no_llseek

doesn't call this function. 

Thanks,
-Kame

