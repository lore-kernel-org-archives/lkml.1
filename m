Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbYHKXjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbYHKXjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYHKXjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:39:09 -0400
Received: from gw.goop.org ([64.81.55.164]:54634 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbYHKXjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:39:08 -0400
Message-ID: <48A0CD86.6030704@goop.org>
Date: Mon, 11 Aug 2008 16:38:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Arnd Bergmann <arnd@arndb.de>, "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: checkpoint/restart ABI
References: <20080807224033.FFB3A2C1@kernel>	 <200808090013.41999.arnd@arndb.de> <20080811152201.GB25930@us.ibm.com>	 <200808111853.13854.arnd@arndb.de> <1218484114.5598.43.camel@nimitz>
In-Reply-To: <1218484114.5598.43.camel@nimitz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> Arnd, Jeremy and Oren,
>
> Thanks for all of the very interesting comments about the ABI.  
> Considering that we're still *really* early in getting this concept
> merged up into mainline, what do you all think we should do now?
>
> My main goal here is just to get everyone to understand the approach
> that we're proposing rather than to really fix the interfaces in stone.
> I bet we're going to be changing them a lot before these patches
> actually get in.
>   
Yes.

It seems to me that worrying about ABI at this point is a bit premature.

This feature, as it currently stands, is essentially useless for any 
practical purpose.  Self-checkpointing a single process with no handling 
of non-file file descriptors and no proper handling of file 
file-descriptors is not very useful.

My understanding that this is basically a prototype for a more useful 
multi-process or container-wide checkpoint facility.

While you could try to come up with an extensible file format that would 
be able to handle any future extensions, the chances are you'd get it 
wrong and need to break file format compatibility anyway.

I'm more interested in seeing a description of how you're doing to 
handle things like:

    * multiple processes
    * pipes
    * UNIX domain sockets
    * INET sockets (both inter and intra machine)
    * unlinked open files
    * checkpointing file content
    * closed files (ie, files which aren't currently open, but will be
      soon, esp tmp files)
    * shared memory
    * (Peter, what have I forgotten?)

Having gone through this before, I don't think an all-kernel solution 
can work except for the most simple cases.

Which, come to think of it, is an important point.  What are the 
expected use-cases for this feature?  Do you really mean 
checkpoint/restart?  Do you expect to be able to checkpoint a process, 
leave it running, then "rewind" by restoring the image?  Or does 
checkpoint always atomically kill the source process(es)?  Are you 
expecting to be able to resume on another machine?

Lightweight filesystem checkpointing, such as btrfs provides, would seem 
like a powerful mechanism for handling a lot of the filesystem state 
problems.  It would have been useful when we did this...

    J
