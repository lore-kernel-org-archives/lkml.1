Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbZDBSf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbZDBSf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755998AbZDBSfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:35:10 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:35709 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755709AbZDBSfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:35:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2Fc9nAJFjP2Tk9w0LmZ+6X1tXxCoX4xkmO6V9MM1FpylUlIWPmYJlAJSQtkKGAgtD7BzoXCeEG/3NMXGdI0BCzV4o2ItvfD2hPpDE8WNYR3yKwdfNqsy7GXzl6G11zq1eY+ODVQyZr/ZnTRfcVXJnWcYYeZilpYQR8nJ9VWqGbU=  ;
X-YMail-OSG: eSGxUv4VM1kcS5xfzHf8oOTauxmzhrkJCqv5adiVFr6N5p1wcIB_INMCa37swa4l9G7ZOrzCLAEKkGNa7ILJGu_3olMYoOjcUkbo24BFIlCPATOFBr4F3NtB7Vu1zQUVlepIf_PReHyh29mtyPhcrMv0ajwkIzvlALUhjMvywYM07oduOoonYpC2KdtoK5kqpe4j8054qqWwnsNimtsQRAPjpr1AcGcFAZmfyeYEvf4pBOPc.8Hlik.gjXjIG_oBJ2ObkzxyMS1Rk_06VagIiInp7WCjPE6DQswkO1kbvfAaxphXeU4bo.SXYZcnewNyRxIHVTlKcWVaY3JeWw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: david@lang.hm
Subject: Re: Ext4 and the "30 second window of death"
Date: Fri, 3 Apr 2009 05:34:59 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903291224.21380.info@gnebu.es> <20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904030535.00335.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 05:22:48 david@lang.hm wrote:
> On Wed, 1 Apr 2009, Matthew Garrett wrote:
> 
> >> The other subtlety comes if we add fsync() suppression to laptop mode
> >> --- which is something that Bart Samwel is very interested in doing
> >> and I talked to him at FOSDEM about this.  As Jeff Garzik recently
> >> pointed out, however, if we let the system reorder writes across
> >> fsync() boundaries, or if we combine two writes to the same block
> >> separated by an fsync(), and the system crashes in the middle of
> >> pushing all of these blocks out to the disk, we can end up trashing
> >> the consistency guarantees of a database such as mysql or postgres.
> >> It's a good point, but it only applies if we add fsync() suppression
> >> to laptop mode --- which we haven't done yet.
> >
> > I've got absolutely no idea why anyone would want fsync() to stop
> > meaning "Put my data on the disk please". laptop-mode isn't intended to
> > reduce data integrity - it's intended to batch disk write-outs such that
> > there's a lower risk of needing to perform further write-outs in future.
> > It makes sense for applications which really desperately want
> > information on disk to fsync() (for instance, saving a file in
> > OpenOffice).
> >
> > laptop-mode is something that makes sense as a default behaviour under a
> > lot of circumstances. Adding fsync() suppression means it's utterly
> > impossible to use it in that way. An additional mode would be perfectly
> > reasonable, as long as it's made clear that it's really a request for
> > data to be discarded at some point. The current mode isn't.
> 
> this issue seems pretty straightforward to me
> 
> the apps do fsync (and similar) to the degree that they think their data 
> is important (potentially with config options if they acknowlege that 
> their data isn't _always_ that important)
> 
> the system allows the admin to override the application and say "I'm 
> willing to loose up to X seconds of data for other benifits"
> 
> if this can work cleanly (with the ordering issue that was identified, 
> which may involve having multiple versions of the metadata cached) it 
> seems like a very clean interface.

It isn't just about ordering of writes a a filesystem. A database program
commits a transaction and then tells the client that it is safe. Client
then goes and does <something> in response to that, which may or may not
involve more writes to the filesystem.

Shouldn't applications have a mode to avoid spinning up the disk if it is
so important?
