Return-Path: <linux-kernel-owner+w=401wt.eu-S1751674AbXBPXPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbXBPXPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXBPXPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:15:31 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56435 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbXBPXP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:15:29 -0500
Message-ID: <45D63B1B.4000503@us.ibm.com>
Date: Fri, 16 Feb 2007 17:15:39 -0600
From: "Steve French (smfltc)" <smfltc@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: miklos@szeredi.hu
CC: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: [PATCH] consolidate generic_writepages and mpage_writepages]
References: <1171647615.8468.14.camel@kleikamp.austin.ibm.com>
In-Reply-To: <1171647615.8468.14.camel@kleikamp.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>From: Miklos Szeredi <miklos@szeredi.hu>
>To: akpm@linux-foundation.org
>Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
>Subject: [PATCH] consolidate generic_writepages and mpage_writepages
>Date: 	Fri, 16 Feb 2007 17:23:25 +0100
>
>From: Miklos Szeredi <mszeredi@suse.cz>
>
>Clean up massive code duplication between mpage_writepages() and
>generic_writepages().
>
>The new generic function, write_cache_pages() takes a function pointer
>argument, which will be called for each page to be written.
>
>Maybe cifs_writepages() too can use this infrastructure, but I'm not
>touching that with a ten-foot pole.
>  
>
The cifs case ought to be one of the simpler ones, pseudo-code is pretty 
easy, the hard part is all of the stuff unrelated to cifs:
Ideally if there were generic functions to help out, cifs writepages 
would look roughly like the following

cifs_writepages(struct address_space *mapping, struct writeback_control 
*wbc)
{
   
    while (no more pages to write) {
        /* find writeable file handle for this inode */
        /* find the biggest set of contiguous pages that total less than 
wsize */
        if (packet signing is enabled)
                /* write lock pages so they can not be changed under us 
while we are calculating the checksum */
      
       CIFSSMBWrite2(tree_connection, network_file_handle, array of 
iovecs, number of iovecs);

        if(packet signing was enabled)
                /* unlock pages */

        if(error) {
             set page errors
             if (mounted "hard" )
                   continue; /* retry */
             else /* if no retry possible */
                   return error to caller;
       }
        update bytes written statistics
        update index to point to next set of pages
    }  /* end while loop */
}


If it were even better, CIFSSMBWrite2 could be called async - so that it 
did not have to wait for a network response from Samba (just an ack from 
TCP), before issuing the next write onto the wire - but this would 
require that we could queue a pointer to a completion routine to the mpx 
entry.
