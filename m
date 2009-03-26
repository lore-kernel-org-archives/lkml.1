Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021AbZCZEmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbZCZEmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 00:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZCZEl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 00:41:56 -0400
Received: from mail168c2.megamailservers.com ([69.49.111.68]:56768 "EHLO
	mail168c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061AbZCZEly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 00:41:54 -0400
X-Greylist: delayed 15876 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2009 00:41:54 EDT
X-Authenticated-User: jiri.gaisler.com
Message-ID: <49CAC982.4050507@gaisler.com>
Date: Thu, 26 Mar 2009 01:17:06 +0100
From: Jiri Gaisler <jiri@gaisler.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Alexander Beregalov <a.beregalov@gmail.com>, Theodore Tso <tytso@mit.edu>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sparclinux@vger.kernel.org
Subject: Re: next-20090310: ext4 hangs
References: <a4423d670903110907o7041f4eof92278835aa0c71c@mail.gmail.com> <20090325151122.GA14881@atrey.karlin.mff.cuni.cz> <20090325151516.GB14881@atrey.karlin.mff.cuni.cz> <a4423d670903250818n512b1c67ja1b38db6d09ac7c@mail.gmail.com> <20090325152234.GN23439@duck.suse.cz> <a4423d670903250829w5e9304a7rce24f4220379620f@mail.gmail.com> <20090325161556.GP23439@duck.suse.cz> <a4423d670903251007r72058ca8m28275c1433ab2706@mail.gmail.com> <20090325194316.GQ23439@duck.suse.cz> <a4423d670903251538p3a7c180br1bcfe08c4f044c15@mail.gmail.com> <20090326000035.GB11024@duck.suse.cz>
In-Reply-To: <20090326000035.GB11024@duck.suse.cz>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jan Kara wrote:
>   Hi,
> 
>   thanks for the updated disassembly.
> 
>>   55bab0:       82 10 60 01     or  %g1, 1, %g1
>>                 spin_unlock(&journal->j_list_lock);
>>   55bab4:       40 06 4b 20     call  6ee734 <_spin_unlock>
>>   55bab8:       c2 24 e0 28     st  %g1, [ %l3 + 0x28 ]
>   OK, so it really seems that:
>   jinode->i_flags |= JI_COMMIT_RUNNING;
>   spin_unlock(&journal->j_list_lock);
> 
>   has been compiled to
>   ld [ %l3 + 0x28 ], %g1
>   or  %g1, 1, %g1
>   call  6ee734 <_spin_unlock>
>   st  %g1, [ %l3 + 0x28 ]
> 
>   Which seems like a bug in the compiler or in the way implement compiler
> barriers in spin_unlock() on UP sparc. Or is there some sparc magic by which
> this is correct code? Any clever sparc guy?
> 
> 									Honza


Looks fine to me - the store is made in the branch delay slot
of the call, so it will occur before the first instruction at
the call target address executes.
Jiri.
