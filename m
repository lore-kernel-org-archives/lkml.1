Return-Path: <linux-kernel-owner+w=401wt.eu-S1765989AbZDBXqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765989AbZDBXqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 19:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbZDBXqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 19:46:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43809 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694AbZDBXqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 19:46:32 -0400
Date: Fri, 3 Apr 2009 00:46:17 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: david@lang.hm
Cc: Theodore Tso <tytso@mit.edu>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090402234617.GB9538@srcf.ucam.org>
References: <200904010002.47077.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx> <20090401015010.GB4529@mit.edu> <20090401052050.GA20456@sucs.org> <20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu> <20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> <20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 11:44:20AM -0700, david@lang.hm wrote:
> On Thu, 2 Apr 2009, Matthew Garrett wrote:
> >The solution to "fsync() causes disk spinups" isn't "ignore fsync()".
> >It's "ensure that applications only use fsync() when they really need
> >it", which requires us to also be able to say "fsync() should not be
> >required to ensure that events occur in order".
> 
> ignore the issue of order on the local disk for the moment.
> 
> what should an application do to make sure it's data isn't lost?

fsync().

> however, some (many, most??) users would probably be willing to loose a 
> little e-mail to gain a significant increase in battery life on their 
> laptops.

Then they shouldn't use a mail client that fsync()s.

> today they have no choice (other than picking a mail client that doesn't 
> try to protect it's local data)
> 
> with the proposed addition to laptop mode (delaying fsync until the disk 
> is awake), the user (or more precisely the admin) gains the ability to 
> define this trade-off rather than depending on the application developers 
> all doing this right.

No. Ignoring fsync() makes it difficult for an application to 
inappropriately spin up a disk - but it also makes it *impossible* for 
an application to save data that it genuinely needs to. Doing this in 
kernel means that you have no granularity. You ignore the inappropriate 
fsync()s, but you also ignore the ones that are vitally important. I've 
no objection to the kernel supporting this functionality, but it should 
be /proc/sys/vm/fuck-my-data-harder rather than 
/proc/sys/vm/laptop-mode.

Power management is a tradeoff. Sometimes providing correct 
functionality costs more than providing incorrect functionality. In 
general we strive to carry on providing applications the behaviour they 
expect even if it costs us more power - the alternative leads to users 
disabling power management functionality because they can't trust it. 
Throwing data away isn't an acceptable tradeoff for an extra three 
minutes of battery life for most users.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
