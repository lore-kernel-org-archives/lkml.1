Return-Path: <linux-kernel-owner+w=401wt.eu-S1031361AbXEDQld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031361AbXEDQld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031380AbXEDQld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:41:33 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37970 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031361AbXEDQlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:41:31 -0400
Message-ID: <463B624B.2060802@us.ibm.com>
Date: Fri, 04 May 2007 11:41:47 -0500
From: "Steve French (smfltc)" <smfltc@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: linux-cifs-client@lists.samba.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       samba-technical@lists.samba.org, hch@infradead.org
Subject: Re: [PATCH] CIFS: make sec=none force an anonymous mount
References: <20070504024910.CE97B1638AF@lists.samba.org> <463B50A5.3070500@us.ibm.com> <20070504155710.GB18522@dantu.rdu.redhat.com>
In-Reply-To: <20070504155710.GB18522@dantu.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton wrote:

>On Fri, May 04, 2007 at 10:26:29AM -0500, Steve French (smfltc) wrote:
>  
>
>>Jeff Layton wrote:
>>    
>>
>>>We had a customer report that attempting to make CIFS mount with a null
>>>username (i.e. doing an anonymous mount) doesn't work. Looking through the
>>>code, it looks like CIFS expects a NULL username from userspace in order
>>>to trigger an anonymous mount. The mount.cifs code doesn't seem to ever
>>>pass a null username to the kernel, however.
>>>      
>>>
>>Yes - cifs kernel code expects a NULL username (e.g. "username=") if 
>>you really don't want to pass the default username of the uid of 
>>the current process and you don't set the username explicitly
>>(e.g. in a credential file or mount parameter).
>>
>>Samba userspace tools (and smbfs) handled this by first trying to
>>setup the SMB session using the default user, and if that fails 
>>with access denied then retrying sessionsetup with a null username 
>>string.  This would be easy to change in mount.cifs (ie as long 
>>as username was not explicitly passed on mount then if mount fails
>>with access denied simply add a retry with "username=").  This was
>>discussed at SambaXP.
>>
>>    
>>
>
>Does this mean you're NAK'ing this patch in favor of a userspace fix? My
>perspective is that if someone explicitly requests sec=none, then we ought
>to do an anonymous mount regardless of how the username is set. Would
>you agree that that behavior is what you would want?
>
>
>  
>
Your patch is probably ok to add, although I would like to see if any of 
the other Samba team
had thoughts on this, as "null user" sessions are a fairly obscure part 
of the protocol.  But
even with the kernel change, mount.cifs also should change for a loosely 
related case that of
    1) sec=none is not specified by the user
    2) but username also is not specified explicitly
For that case we need to retry on access denied as if it were a request 
for a "null user" mount
ie send sec=none (or equivalently username=) the 2nd time.  This gets 
more complicated
since mount.cifs also has to retry on a couple of other cases (e.g. when 
the server does
not support port 445 but does not take the standard server string 
"*SMBSERVER"
on the RFC1001 called name).

If there are no objections from any of the other Samba guys I will take 
your patch which has
the effect of treating "sec=none" as meaning "ingore any userid if 
specified, and set the username to null
on the session setup").   That is consistent with what we documented.

I had though for a while that a user who mounts passing both "sec=none" 
and a username might
also expect to get a null password (they could have done this with 
"guest" or with "password=") or
might want to try to send the password in plaintext - but I doubt that 
we want to support
a user who wants to send the password plaintext without the server 
requiring it (and in that
case cifs can be built and configured to allow plaintext if absolutely 
necessary to support
those ancient servers).


Basically if we set username to null in kernel when (sec=none)

>Thanks,
>Jeff
>
>  
>

