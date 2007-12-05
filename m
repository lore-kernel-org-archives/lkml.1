Return-Path: <linux-kernel-owner+w=401wt.eu-S1752447AbXLEX2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbXLEX2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 18:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXLEX2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 18:28:14 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:3758 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbXLEX2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 18:28:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=d8qoqT4Kb3Htaz31VQN6QrFo9xjR/uOEd86KlhZ/mjcbwnteA9PzBLGpHYWtPA18B+H+J5LPPqR8l3YOi7l5bvQ6N9SybTOv5lLhbJFq4Y3LCc3BkhqKy3noKZ2YqTeqdAnRMcPA3x1JCKaStLYPRox5doBb+eG1fJO3d6hInUQ=
Message-ID: <47573403.1060203@gmail.com>
Date: Thu, 06 Dec 2007 08:28:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [PATCH] depmod: sort output according to modules.order
References: <47555AF1.8090304@gmail.com> <47555C64.8070607@gmail.com> <20071205072529.GA5681@uranus.ravnborg.org> <47565452.3010800@gmail.com> <47565486.8050701@gmail.com> <20071205190609.GA14997@uranus.ravnborg.org>
In-Reply-To: <20071205190609.GA14997@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Wed, Dec 05, 2007 at 04:34:30PM +0900, Tejun Heo wrote:
>> Tejun Heo wrote:
>>>> It would also simplify the kbuild integration if depmod
>>>> could read the modules as a space separated list where
>>>> duplicates are allowed.
>>>> If we do so then the is no reason to escape to the shell
>>>> in Makeilfe.build and we do not have to remove duplicates either.
>>> I'm no Makefile expert so no doubt my modifications are ugly.  But I
>>> think producing a file w/ duplicates in it is just ugly.
>> Oh, and, depmod should do just fine with duplicate entries as it is.
> What is the purpose of REMOVE-DUP then?
> If depmod handle duplicate entries there is no need to remove them.

As I said, I don't think leaving duplicate lines in a file which will be
installed, distributed and used widely is the RTTD.  There can be other
uses of the file.  For example, the file can be parsed and modified by
distro specific module selector.  Sure, all of them can be made to deal
with dup entries but that's just not the right place to solve the problem.

> And this change in Makefile.lib seems bogus:
> +# make sure '/' follows subdirs
> +subdir-y       := $(patsubst %//,%/, $(addsuffix, /,$subdir-y))
> +subdir-m       := $(patsubst %//,%/, $(addsuffix, /,$subdir-m))

Some subdir-y|m entries have following / while others don't.  subdir-y|m
are lax about because either way it points to subdirectory.  The above
two lines are to normalize them so that there's no surprises when
concatenating file name to it.  I think it's a good idea to have the
above with or without other changes.

> I commented it out and with my config everything seems to still
> work as expected.

Yeah, it depends on config.  If you don't have subdir-y|m entries which
don't have following '/', it will work just fine.  If you do, it will break.

> And I get scripts/mod/modpost built in a mrproper tree again (bug!).

This I dunno much about.

> subdir-y and subdir-m does not point to directories that
> contains modules (built-in or not) so they can be ignored for modorder.

I didn't know that.  Is it forced that modules can't be put in
subdir-y|m directories?  What happens if I do that?

> I did a quick hack up top of your patch and came up with the following.
> I just checked that if I manually ran remove-dup then the resulting
> module.order files were identical with a simple configuration (50 modules).

e.g. Some of USB modules are listed twice in config.  They'll appear twice.

> And I did not try out depmod at all.
> Feel free to use this as an updated patch.

Ah.. that looks much less hacky.  Thanks.  I'll submit an updated
version as soon as above issues are settled.

Thanks.

-- 
tejun
