Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbXIGVQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbXIGVQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 17:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbXIGVQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 17:16:45 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:34201 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750937AbXIGVQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 17:16:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=H712rvlQzAL5O5zk2tFrH8G25cNRXbTMelsDwR0dPgKWK0HMqGj+bncnpgXdE/eYphibAs8B/sE6nmODvOk5KtHf5JTgCjPdBVtbevJAALOfyPXKQclFloROAMW1Oo6ZP72XpZm3ruN78CHqbOU7LoogPXb0ya+bT5NT2xJKe/8=  ;
X-YMail-OSG: 6AqQeEwVM1nft._1OjWvERf0MIJ7JarY99hLfwWz5jsPRN.smzmFpTPHZVlnzrTYluRlsd8bhg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: patch: improve generic_file_buffered_write() (2nd try 1/2)
Date: Sat, 8 Sep 2007 17:14:09 +1000
User-Agent: KMail/1.9.5
Cc: Bernd Schubert <bs@q-leap.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       brian@clusterfs.com
References: <200709051546.06224.bs@q-leap.de> <200709081415.54211.nickpiggin@yahoo.com.au> <87hcm6chtb.fsf@informatik.uni-tuebingen.de>
In-Reply-To: <87hcm6chtb.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709081714.10278.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 September 2007 07:00, Goswin von Brederlow wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> > Anyway, there are fixes for this deadlock in Andrew's -mm tree, but
> > also a workaround for the NFSD problem in git commit 29dbb3fc. Did
> > you try a later kernel to see if it is fixed there?
>
> I had a chance to look up that commit (git clone took a while so sorry
> for writing 2 mails). It is present in 2.6.23-rc5 so I already noticed
> it when merging our patch in 2.6.23-rc5.
>
> Upon closer reading of the patch though I see that it will indeed
> prevent writes by the nfsd to be split smaller than PAGE_SIZE and it
> will cause filemap_copy_from_user[_iovec] to be called with a source
> spanning multwhat to do in cambridge pubiple pages.

OK, good.


> So the commit 29dbb3fc should have a simmilar, slightly better even,
> gain for the nfsd and other kernel space segments. But it will not
> improve writes from user space, where ~14% of the commits were saved
> during a days work for me.
>
>
> Now I have a question about fault_in_pages_readable(). Can I call that
> for multiple pages and then call __grab_cache_page() without risking
> one of the pages from getting lost again and causing a deadlock?

No. The existing mainline code is buggy, and it is just hoping that
the userspace page does not get paged out between the fault_in_pages
and the subsequent copy_from_user.

If you do multiple fault_in_pages_readable(), you probably have less
chance of deadlocking, but on the 2nd call, you might still have to
wait for a long time to page in, during which time the 1st page may get
paged out.

But there is a proper solution in -mm with the write_begin aop.
