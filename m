Return-Path: <linux-kernel-owner+w=401wt.eu-S1764971AbXIMTqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764971AbXIMTqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbXIMTpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:45:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbXIMTpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:45:53 -0400
Message-ID: <46E9933D.5070802@redhat.com>
Date: Thu, 13 Sep 2007 15:45:01 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Pavel Emelyanov <xemul@openvz.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Memory shortage can result in inconsistent flocks state
References: <46E68C35.7040001@openvz.org> <46E98F0C.10504@redhat.com> <20070913193439.GA18052@fieldses.org>
In-Reply-To: <20070913193439.GA18052@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2007 03:34 PM, J. Bruce Fields wrote:
>> Doesn't that create a leak in some cases?
>>
>>>         for_each_lock(inode, before) {
>>>                 struct file_lock *fl = *before;
>>>                 if (IS_POSIX(fl))
>>>                         break;
>>>                 if (IS_LEASE(fl))
>>>                         continue;
>>>                 if (filp != fl->fl_file)
>>>                         continue;
>>>                 if (request->fl_type == fl->fl_type)
>>>                         goto out;  <<<<<<<<<<<<<<<< LEAK?
> 
> You mean, a leak of the memory allocated for new_fl?  That's freed at
> the exit labeled with "out".  It's the only exit:
> 
> 	out:
> 	        unlock_kernel();
> 		if (new_fl)
> 			locks_free_lock(new_fl);
> 		return error;
> 
> And new_fl is initially NULL, assigned only once by the allocation, then
> assigned to NULL only at the very end when we know we've succeeded.
> 
> Am I missing something else?
> 

Never mind, I didn't look closely enough. Looks good to me.

