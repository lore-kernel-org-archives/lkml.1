Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbZDWFeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbZDWFeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 01:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZDWFeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 01:34:09 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38041 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbZDWFeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 01:34:08 -0400
Date: Thu, 23 Apr 2009 07:34:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Wolfram Strepp <wstrepp@gmx.de>
Subject: Re: [BUG] rbtree bug with mmotm 2009-04-14-17-24
Message-ID: <20090423053402.GH4593@kernel.dk>
References: <49EF293F.4030504@opengridcomputing.com> <49EF2C32.4030409@opengridcomputing.com> <20090422163032.GV4593@kernel.dk> <20090422163705.GW4593@kernel.dk> <49EF5F31.30408@opengridcomputing.com> <20090422183406.GA4593@kernel.dk> <49EF6929.9020600@opengridcomputing.com> <20090422192216.GE4593@kernel.dk> <49EF7B40.9050505@opengridcomputing.com> <49EF7F3A.1070809@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EF7F3A.1070809@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22 2009, Steve Wise wrote:
> Steve Wise wrote:
>> Jens Axboe wrote:
>>
>>  
>>
>>>> Still crashes with this variant:
>>>>     
>>>
>>> OK, so please try and revert a36e71f996e25d6213f57951f7ae1874086ec57e
>>> and see if that works?
>>>
>>> Or, better yet, please try and revert
>>> 55a63998b8967615a15e2211ba0ff3a84a565824 first. If that doesn't work,
>>> try the above revert.
>>>
>>>   
>>
>> Reverting 55a63998b8967615a15e2211ba0ff3a84a565824 did the trick.
>>
>>
>> Steve.
>>
>>
>
> <snipit from 55a63998b8967615a15e2211ba0ff3a84a565824>
>
> @@ -200,17 +197,14 @@ static void __rb_erase_color(struct rb_node *node,  
> struct rb_node *parent,
>                        {
>                                if (!other->rb_left ||  
> rb_is_black(other->rb_left))
>                                {
> -                                       register struct rb_node *o_right;
> -                                       if ((o_right = other->rb_right))
> -                                               rb_set_black(o_right);
> +                                       rb_set_black(other->rb_right);
>                                        rb_set_red(other);
>                                        __rb_rotate_left(other, root);
>                                        other = parent->rb_left;
>                                }
>                                rb_set_color(other, rb_color(parent));
>                                rb_set_black(parent);
> -                               if (other->rb_left)
> -                                       rb_set_black(other->rb_left);
> +                               rb_set_black(other->rb_left);
>                                __rb_rotate_right(parent, root);
>                                node = root->rb_node;
>                                break;
>
>
> I don't know this code, but isn't the 'if (other->rb_left)' really  
> needed?  Or is it always true that if '!other->rb_left' is true entering  
> this snipit, then after executing the first 'if' block, then  
> 'other->rb_left' must be a valid ptr? (how's that for confusing english? 
> :)

Heh, not sure. What is sure is that the commit in question is
problematic. Either because it itself has a bug, or because it exposes a
bug elsewhere in the rbtree code. So I'd suggest we just revert that
commit ASAP.

-- 
Jens Axboe

