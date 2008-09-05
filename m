Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYIETlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYIETlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 15:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYIETlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 15:41:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59170 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbYIETlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 15:41:42 -0400
Date: Fri, 5 Sep 2008 21:45:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Hamid R. Jahanjou" <hamid.jahanjou@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
Message-ID: <20080905194501.GZ18288@one.firstfloor.org>
References: <48BFCECE.90103@gmail.com> <87iqtbuez9.fsf@basil.nowhere.org> <48C19648.8030002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C19648.8030002@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 11:57:52PM +0330, Hamid R. Jahanjou wrote:
> > In general the code would be much nicer if you didn't pass around 
> > all that much in a structure (which is just a fancy way to have
> > a function with lots of arguments) Perhaps try to restructure
> > it a bit to make this smaller? Ideally clustering_info should disappear
> > or at least get much smaller.
> >   
> 
> Thanks for the review and the comments.
> Do you consider the clustering_info struct to hurt the readability
> of the code or there is some other technical reasons ?

It's a fancy way to have a function with lots of arguments
and having lots of arguments is typically a sign for a poor code
structure, with functions not being properly separated.

I know the standard scanner does it too, but it's also somewhat
poor there and especially there's no excuse for doing it in much
simpler code/

> 
> > I didn't quite understand the "adjust the value of our search by
> > the allocation order". The allocation order should be normally 0.
> > I think having a tunable for the cluster sizes would be a good idea.
> > At some point they might be even device dependent (e.g. on a flash
> > device you would like to have them roughly erase block sized)
> >   
> 
> The allocation order value is initially passed to the try_to_free_pages()

Yes, but that has nothing to do in how much you should swap cluster.

AFAIK the main motivation for swap clustering is to avoid the extreme
seekiness that happens during swap in (that is the main reason
why swap on Linux often takes so long). And also to use the IO
device well. IO devices today typically have a "minimum useful 
unit of IO" which is much larger than a page. Typically it's at least a 
MB, sometimes even more e.g. on flash or on some RAID controllers.  

Making it even larger is good to avoid seeks on read which are very 
costly on spinning disks.

Also for user application swapping the order will be near always 0
(except for large page users, but that's really a exotic corner case today)
And clustering for one page doesn't make much sense.

So I don't think you should care about that order, but make it a 
tunable and experiment what the best values are on different IO
devices and then possibly later make it dependent on the device.

-Andi
-- 
ak@linux.intel.com
