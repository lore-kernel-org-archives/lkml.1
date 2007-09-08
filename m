Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbXIHMI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbXIHMI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 08:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXIHMIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 08:08:52 -0400
Received: from mailgw.cvut.cz ([147.32.3.235]:58734 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbXIHMIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 08:08:51 -0400
Message-ID: <46E290D3.10304@vc.cvut.cz>
Date: Sat, 08 Sep 2007 05:08:51 -0700
From: Petr Vandrovec <vandrove@vc.cvut.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.6) Gecko/20070802 Iceape/1.1.4 (Debian-1.1.4-1)
MIME-Version: 1.0
To: dean gaudet <dean@arctic.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>, ak@suse.de,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Intel Memory Ordering White Paper
References: <200709071526.51169.jesse.barnes@intel.com> <alpine.LFD.0.999.0709080020040.9047@evo.linux-foundation.org> <200709090334.27677.nickpiggin@yahoo.com.au> <200709090348.28076.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709080429420.27088@twinlark.arctic.org>
In-Reply-To: <Pine.LNX.4.64.0709080429420.27088@twinlark.arctic.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dean gaudet wrote:
> On Sun, 9 Sep 2007, Nick Piggin wrote:
> 
>> I've also heard that string operations do not follow the normal ordering, but
>> that's just with respect to individual loads/stores in the one operation, I
>> hope? And they will still follow ordering rules WRT surrounding loads and
>> stores?
> 
> see section 7.2.3 of intel volume 3A...
> 
> "Code dependent upon sequential store ordering should not use the string 
> operations for the entire data structure to be stored. Data and semaphores 
> should be separated. Order dependent code should use a discrete semaphore 
> uniquely stored to after any string operations to allow correctly ordered 
> data to be seen by all processors."
> 
> i think we need sfence after things like copy_page, clear_page, and 
> possibly copy_user... at least on intel processors with fast strings 
> option enabled.

I do not think.  I believe that authors are trying to say that

struct { uint8 lock; uint8 data; } x;

lea (x.data),%edi
mov $2,%ecx
std
rep movsb

to set both data and lock does not guarantee that x.lock will be set 
after x.data and that you should do

lea (x.data),%edi
std
movsb
movsb  # or mov (%esi),%al; mov %al,(%edi), but movsb looks discrete 
enough to me

instead (and yes, I know that my example is silly).
							Petr

