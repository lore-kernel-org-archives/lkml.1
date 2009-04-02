Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbZDBSos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbZDBSos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZDBSog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:44:36 -0400
Received: from mail.lang.hm ([64.81.33.126]:52795 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbZDBSof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:44:35 -0400
Date: Thu, 2 Apr 2009 11:44:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Theodore Tso <tytso@mit.edu>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
In-Reply-To: <20090402182925.GA4502@srcf.ucam.org>
Message-ID: <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm>
References: <200903311452.05210.info@gnebu.es> <20090331134547.GJ13356@mit.edu> <200904010002.47077.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx> <20090401015010.GB4529@mit.edu> <20090401052050.GA20456@sucs.org> <20090401151219.GA12285@srcf.ucam.org>
 <20090401173521.GA15423@mit.edu> <20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> <20090402182925.GA4502@srcf.ucam.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009, Matthew Garrett wrote:

> On Thu, Apr 02, 2009 at 11:22:48AM -0700, david@lang.hm wrote:
>> On Wed, 1 Apr 2009, Matthew Garrett wrote:
>>> laptop-mode is something that makes sense as a default behaviour under a
>>> lot of circumstances. Adding fsync() suppression means it's utterly
>>> impossible to use it in that way. An additional mode would be perfectly
>>> reasonable, as long as it's made clear that it's really a request for
>>> data to be discarded at some point. The current mode isn't.
>>
>> this issue seems pretty straightforward to me
>>
>> the apps do fsync (and similar) to the degree that they think their data
>> is important (potentially with config options if they acknowlege that
>> their data isn't _always_ that important)
>>
>> the system allows the admin to override the application and say "I'm
>> willing to loose up to X seconds of data for other benifits"
>>
>> if this can work cleanly (with the ordering issue that was identified,
>> which may involve having multiple versions of the metadata cached) it
>> seems like a very clean interface.
>
> It does, but it's a different interface to the current one with a
> different aim and a different set of tradeoffs. The current behaviour of
> laptop-mode is that fsync() results in things hitting disk. The only
> configurability of laptop-mode is how long it then waits to flush out
> everything else as well.
>
> The solution to "fsync() causes disk spinups" isn't "ignore fsync()".
> It's "ensure that applications only use fsync() when they really need
> it", which requires us to also be able to say "fsync() should not be
> required to ensure that events occur in order".

ignore the issue of order on the local disk for the moment.

what should an application do to make sure it's data isn't lost?

let's not talk a database here, let's talk something simpler, like a POP3 
mail client (even though I strongly favor IMAP ;-)

it wants to have the message saved before it deletes it from the server.

how should it try to do this?

the only portable method is to fsync the file after it's written and 
before sending the delete to the server.

so your mail client _should_ issue fsync calls.

however, some (many, most??) users would probably be willing to loose a 
little e-mail to gain a significant increase in battery life on their 
laptops.

today they have no choice (other than picking a mail client that doesn't 
try to protect it's local data)

with the proposed addition to laptop mode (delaying fsync until the disk 
is awake), the user (or more precisely the admin) gains the ability to 
define this trade-off rather than depending on the application developers 
all doing this right.

without this, we end up in a situation like the powertop wakeups. it only 
takes one 'buggy' application to destroy your power management and 
performance. but in this case, the application that is 'buggy' from a 
power management point of view may be entirely correct from a data safety 
point of view.

David Lang
