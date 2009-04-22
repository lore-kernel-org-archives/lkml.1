Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZDVUdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZDVUdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbZDVUdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:33:03 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:36633 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755054AbZDVUdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:33:00 -0400
Message-ID: <49EF7F3A.1070809@opengridcomputing.com>
Date: Wed, 22 Apr 2009 15:34:02 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Wolfram Strepp <wstrepp@gmx.de>
Subject: Re: [BUG] rbtree bug with mmotm 2009-04-14-17-24
References: <49EE42CC.7070002@opengridcomputing.com> <20090422131703.GO4593@kernel.dk> <49EF2882.1020306@opengridcomputing.com> <49EF293F.4030504@opengridcomputing.com> <49EF2C32.4030409@opengridcomputing.com> <20090422163032.GV4593@kernel.dk> <20090422163705.GW4593@kernel.dk> <49EF5F31.30408@opengridcomputing.com> <20090422183406.GA4593@kernel.dk> <49EF6929.9020600@opengridcomputing.com> <20090422192216.GE4593@kernel.dk> <49EF7B40.9050505@opengridcomputing.com>
In-Reply-To: <49EF7B40.9050505@opengridcomputing.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Wise wrote:
> Jens Axboe wrote:
>
>  
>
>>> Still crashes with this variant:
>>>     
>>
>> OK, so please try and revert a36e71f996e25d6213f57951f7ae1874086ec57e
>> and see if that works?
>>
>> Or, better yet, please try and revert
>> 55a63998b8967615a15e2211ba0ff3a84a565824 first. If that doesn't work,
>> try the above revert.
>>
>>   
>
> Reverting 55a63998b8967615a15e2211ba0ff3a84a565824 did the trick.
>
>
> Steve.
>
>

<snipit from 55a63998b8967615a15e2211ba0ff3a84a565824>

@@ -200,17 +197,14 @@ static void __rb_erase_color(struct rb_node *node, 
struct rb_node *parent,
                        {
                                if (!other->rb_left || 
rb_is_black(other->rb_left))
                                {
-                                       register struct rb_node *o_right;
-                                       if ((o_right = other->rb_right))
-                                               rb_set_black(o_right);
+                                       rb_set_black(other->rb_right);
                                        rb_set_red(other);
                                        __rb_rotate_left(other, root);
                                        other = parent->rb_left;
                                }
                                rb_set_color(other, rb_color(parent));
                                rb_set_black(parent);
-                               if (other->rb_left)
-                                       rb_set_black(other->rb_left);
+                               rb_set_black(other->rb_left);
                                __rb_rotate_right(parent, root);
                                node = root->rb_node;
                                break;


I don't know this code, but isn't the 'if (other->rb_left)' really 
needed?  Or is it always true that if '!other->rb_left' is true entering 
this snipit, then after executing the first 'if' block, then 
'other->rb_left' must be a valid ptr? (how's that for confusing english? :)

Steve


