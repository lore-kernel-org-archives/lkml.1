Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYJTSHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYJTSHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYJTSHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:07:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:32420 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYJTSH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:07:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DC82yvojDcu0W/h9qcn+7NmQktdS/UMi2duuNLm6vgoxesQH9k5+DSPj5BsApX9n9x
         duITG/igf+QDZ9C5Tu4mbYNd2eX48ltSV3PGFABqcpTgCNpX8PKiuG+32he45uJFqn16
         GDNecT9Mv0IsvQ9mWAkzkJ0By/HumsAzCnjB8=
Message-ID: <787b0d920810201107p7ea3c1een2b7809d5cbfbc6bc@mail.gmail.com>
Date: Mon, 20 Oct 2008 14:07:28 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Mel Gorman" <mel@csn.ul.ie>
Subject: Re: [PATCH 0/2] Report the size of pages backing VMAs in /proc V3
Cc: adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081020100643.GA22647@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920810200218o5f26ee7bj9f8c0e71606dd5cb@mail.gmail.com>
	 <20081020100643.GA22647@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 6:06 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> On (20/10/08 05:18), Albert Cahalan didst pronounce:

>> Looping on stat() while chopping off suspected tags is dreadful.
>> Besides just being gross, it's slow.
>
> You're probably right. It's a bit weird that it's what you have to do to
> figure out if the file in /proc/PID/maps is really there or not.

Actually you can't do this, because of directory permissions.

>> Obviously, every author of a /proc-based tool has been forced to
>> take a random guess at the ABI. The /proc/*/smaps is so gross and
>> that I put off writing a parser for years.
>
> I intend to take a stab at it for the purposes of teaching pmap to print
> the pagesizes if the smaps change gets picked up.

FYI, "KernelPageSize" is at least unique under the perfect
hash function I'm using to parse the damn smaps file.

hash = ( ( (s[8]&15) + (s[1]&15) ) ^ (s[0]&3) ) & 31;

I have to wonder if we'll be getting mixed page sizes
within a single mapping, making such info unusable.

>> Right before the filename, you can add anything except a '/'.
>> You could add a few columns of numbers or a second flags field.
>
> My fear was about parsers that hard-coded what number field stored the
> filename. If a column was added for pagesize for example, then parsers
> would think the pagesize was the filename.

It's possible. Every parser I've examined does strchr()
or similar to find that '/' character.

Maybe try some dummy patches in a linux-next kernel?
Give each one a month. You could do "xyz" concatenated
to the flags, a second "rwx" concatenated to the flags,
a single column of "0" before the filename, and several
columns of "parsertest" before the filename.

> Now, that is an interested idea, albeit it's not one that is easily
> human-readable and would need a second parser like pmap but that's ok. If
> parsing smaps turns into a total pain in the ass

I assure you that parsing smaps is a total pain in the ass,
especially if you want tolerable performance. Something
like "top" is not viable if it performs like a Python script.

>> BTW, I'm thinking that the /proc/*/*maps files fail when the
>> lines exceed 4096 bytes. The pathname may legitimately be that
>> long, plus it can be backslash escaped, plus there is all the
>> junk on the beginning.
>
> Yes. While it's unlikely to be exceeded, a file could be 4096 bytes long
> and the other fields will then cause a problem. It was because of things
> like this, I was ok with dropping the idea of adding (attribute[=value])
> from the end of the filename.

"unlikely" is not something one should trust. I think you
can even get a name longer than 4096 bytes if you make
directories relative to the current directory and keep
changing directories as you make the directories.
Then double that with backslashes becoming \\ or
newlines becoming \n (must be escaped) in the output.

I think /proc/*/maps has been broken ever since it was
converted to seq_file, and maybe ever since it got filenames.
Prior to the filenames, lines were fixed-width records.
