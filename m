Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbXHTAbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbXHTAbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 20:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbXHTAbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 20:31:17 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:37880 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXHTAbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 20:31:16 -0400
X-Greylist: delayed 3745 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Aug 2007 20:31:16 EDT
Message-ID: <46C8D124.4030701@home.nl>
Date: Mon, 20 Aug 2007 01:24:20 +0200
From: Rene Herman <rene.herman@home.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: Mike Mohr <akihana@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: group ownership of tun devices -- nonfunctional?
References: <8Tpwf-3Nb-1@gated-at.bofh.it> <E1IMnHK-00012c-VC@be1.lrz> <46C86B6C.8090209@home.nl> <Pine.LNX.4.58.0708192333170.2426@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0708192333170.2426@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Neem contact op met support@home.nl voor meer informatie
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2007 11:42 PM, Bodo Eggert wrote:

> On Sun, 19 Aug 2007, Rene Herman wrote:
> 
>> On 08/19/2007 06:05 PM, Bodo Eggert wrote:
>>
>>> IMHO the check is broken:
>>>
>>> +               if (((tun->owner != -1 &&
>>> +                     current->euid != tun->owner) ||
>>> +                    (tun->group != -1 &&
>>> +                     current->egid != tun->group)) &&
>>> +                    !capable(CAP_NET_ADMIN))
>>>                         return -EPERM;
>>>
>>> It should be something like:
>>>
>>> +               if (!((tun->owner == tun->owner) ||
>>> +                     (tun->group == tun->group) ||
>> ???
> 
> Argh, I edited asuming the same order of variables. Substitute 
> current->e{uid,gid} for one of the sides.

Okay. Just had to ask. That looked so odd...

>>> +                     capable(CAP_NET_ADMIN)))
>>>                         return -EPERM;
> 
> The intended semantics is If the user is not
>  * the allowed user
> or
>  * member of the allowed group
> or
>  * cabable of CAP_NET_ADMIN
> then error out. I'm asuming

There is a short description of the desired semantics in the link that was 
posted:

http://lkml.org/lkml/2007/6/18/228

===
The user now is allowed to send packages if either his euid or his egid
matches the one specified via tunctl (via -u or -g respecitvely). If both
gid and uid are set via tunctl, both have to match.
===

Paraphrasing the original code above, it's saying:

if ((owner_is_set && does_not_match) || (group_is_set && does_not_match))
	bugger_off_unless(CAP_NET_ADMIN);

or reverting the logic:

if ((owner_is_unset || does_match) && (group_is_unset || does_match))
	good_to_go();

which probably matches the intention -- we're good to go only if the 
credentials that are set also match.

Rene.
