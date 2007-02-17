Return-Path: <linux-kernel-owner+w=401wt.eu-S965127AbXBQKPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965127AbXBQKPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 05:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965133AbXBQKPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 05:15:50 -0500
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:54661 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965126AbXBQKPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 05:15:50 -0500
To: smfltc@us.ibm.com
CC: shaggy@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <45D63B1B.4000503@us.ibm.com> (smfltc@us.ibm.com)
Subject: Re: [Fwd: [PATCH] consolidate generic_writepages and mpage_writepages]
References: <1171647615.8468.14.camel@kleikamp.austin.ibm.com> <45D63B1B.4000503@us.ibm.com>
Message-Id: <E1HIMQO-0002EX-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 17 Feb 2007 11:04:12 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >Maybe cifs_writepages() too can use this infrastructure, but I'm not
> >touching that with a ten-foot pole.
> >  
> >
> The cifs case ought to be one of the simpler ones, pseudo-code is pretty 
> easy, the hard part is all of the stuff unrelated to cifs:
> Ideally if there were generic functions to help out, cifs writepages 
> would look roughly like the following
> 
> cifs_writepages(struct address_space *mapping, struct writeback_control 
> *wbc)
> {
>    
>     while (no more pages to write) {
>         /* find writeable file handle for this inode */
>         /* find the biggest set of contiguous pages that total less than 
> wsize */
>         if (packet signing is enabled)
>                 /* write lock pages so they can not be changed under us 
> while we are calculating the checksum */
>       
>        CIFSSMBWrite2(tree_connection, network_file_handle, array of 
> iovecs, number of iovecs);
> 
>         if(packet signing was enabled)
>                 /* unlock pages */
> 
>         if(error) {
>              set page errors
>              if (mounted "hard" )
>                    continue; /* retry */
>              else /* if no retry possible */
>                    return error to caller;
>        }
>         update bytes written statistics
>         update index to point to next set of pages
>     }  /* end while loop */
> }

write_cache_pages() now takes care of the 

     while (no more pages to write) {
     }

part.  All you have to do is to make the body of the loop into a
function and pass it a structure with the data you want to preserve
between invocations.

The hard part is untangling the breaks and continues.

Miklos
