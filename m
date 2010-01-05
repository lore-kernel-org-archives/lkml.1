Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853Ab0AEN2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab0AEN2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 08:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256Ab0AEN2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:28:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:47416 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab0AEN2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:28:53 -0500
Date: Tue, 5 Jan 2010 05:31:17 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: strict copy_from_user checks issues?
Message-ID: <20100105053117.6a7c3377@infradead.org>
In-Reply-To: <20100105131911.GC5480@osiris.boeblingen.de.ibm.com>
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com>
	<20100104174308.0790757c@infradead.org>
	<20100105094857.GB5480@osiris.boeblingen.de.ibm.com>
	<201001051347.21309.arnd@arndb.de>
	<20100105131911.GC5480@osiris.boeblingen.de.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010 14:19:11 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Tue, Jan 05, 2010 at 01:47:20PM +0100, Arnd Bergmann wrote:
> > On Tuesday 05 January 2010, Heiko Carstens wrote:
> > > On Mon, Jan 04, 2010 at 05:43:08PM -0800, Arjan van de Ven wrote:
> > > > On Mon, 4 Jan 2010 16:43:45 +0100
> > > > Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > > > > x86 and sparc return -EFAULT in copy_from_user instead of the
> > > > > number of not copied bytes as it should in case of a detected
> > > > > buffer overflow. That might have unwanted side effects. I
> > > > > would guess that is a bug.
> > > > 
> > > > killing the bad guy in case of a real buffer overflow is
> > > > appropriate.. this should never trigger for legitimate users.
> > > 
> > > The point I tried to make is that no caller of copy_from_user can
> > > assume that it would ever return -EFAULT. And if any caller does
> > > so it is broken. But then again it probably doesn't matter in
> > > this case as long as something != 0 is returned.
> > 
> > To quote simple_read_from_buffer():
> > 
> >         size_t ret;
> > 	...
> >         ret = copy_to_user(to, from + pos, count);
> >         if (ret == count)
> >                 return -EFAULT;
> >         count -= ret;
> >         *ppos = pos + count;
> >         return count;
> > 
> > If copy_from_user() returns a negative value, bad things happen to
> > f_pos and to the value returned from the syscall. Many read()
> > file_operations do this similarly, and I wouldn't be surprised if
> > this could be turned into a security exploit for one of them (not
> > simple_read_from_buffer probably).
> 
> Thanks Arnd. I was looking for such an example. That's why I was
> about to send the patch below (untested).


Acked-by: Arjan van de Ven <arjan@linux.intel.com>


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
