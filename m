Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbXIVBkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbXIVBkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 21:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbXIVBkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 21:40:04 -0400
Received: from barikada.upol.cz ([158.194.242.200]:56051 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbXIVBkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 21:40:01 -0400
Date: Sat, 22 Sep 2007 03:55:33 +0200
To: Rob Landley <rob@landley.net>, "Gross, Mark" <mark.gross@intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Michael Opdenacker <michael@free-electrons.com>, linux-tiny@selenic.com,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Message codes (Re: [Announce] Linux-tiny project revival)
Message-ID: <20070922015533.GP24301@flower.upol.cz>
References: <46F1645D.9050406@am.sony.com> <E1IYWps-0006fQ-83@flower> <5389061B65D50446B1783B97DFDB392D07126ACB@orsmsx411.amr.corp.intel.com> <200709211615.39898.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709211615.39898.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 04:15:39PM -0500, Rob Landley wrote:
[]
> > >Not all, but critical info, that must exist in human-readable form of
> > >course.
> >
> > I disagree.  For a production product the you want minimal information
> > to reduce the communication bandwidth required between the remote
> > customer and the support organization.
> >
> > In fact there is a good argument that you don't what the remote customer
> > to know enough to start guessing.
> 
> Don't use Linux then.  Open source is a horrible fit for the way you think.
> 
> I'm sympathetic to "shrink the binary size" arguments.  I'm not really 
> sympathic to "keep the customer in the dark intentionally" arguments, whether 
> the justification is "because they're stupid", "to increase dependency on our 
> support staff", or any other reason.

{1} 

> > >Seriously. When in the Windows there are only messages like:
> > >
> > >    "Error (Code:0x00002012)".
> >
> > Now it's been ~8 years since I did any serious windows work, but if I
> > recall correctly ALL THE FRICKING TIME!!! When was the last time you've
> > seen a bug check on windows?  This is about all you get.
> 
> I believe he was holding it up as a bad example, and definitely not something 
> we want to emulate.

I tried to show, that keeping users in compete information vacuum is a
bad thing. Even without sources, _configuration_ makes another area of
mis-working and bugs, usually addressed by reinstalling.

That may be bad example, because here talk is about developers and
testers, who are not just ordinary users. And by applying Torvalds's Law,
all users are such in some degree. That's why {1} in your reply, Rob,
makes perfect sense.

If Mark have a bad experience with lusers only, then i just can say: what
a pity! AFAIK nobody can read somebody's plain-bin OOP output.

Anyway, anything must be opted by config options, even schedulers. But
maintenance and flame wars rule otherwise :).

What i can propose is form of binary-only "printk", where all info:
diagnostic, error, bug, statistics messages (in not debugging
environment, of course), is just fed right to output buffer (see,
pa, no kmallocs). Info itself must have structured content, that makes it
easy to extract and locate human-readable representation of both message
and data.

This doesn't address loglevels, though.

Implementation (seems) as easy as feeding output to `od` to have
unambiguous form of various troublesome bytes, like "0x00" and "0x0A",

Structuring, who is printing, i.e. arch code, fs, driver whatever, must be
agreed:

*  Profiles[0]: originator's ID of a message is a byte (or word, or double word)
   0x01 - arch, 0x02 - fs, 0x03 - net, 0x04 - hw drivers, etc.

*  Data itself can be sent in form of [0]

[0] Banana -- extendable protocol for sending and receiving s-expressions
    http://twistedmatrix.com/projects/core/documentation/specifications/banana.html

and having shell script with functions, that have names that correspond
to actual structured content:
_*_
olecom@flower:/tmp$ sh banana.sh < banana.c >bb
olecom@flower:/tmp$ sh -c '. ./bb ; _07080'
start
olecom@flower:/tmp$ sh -c '. ./bb ; _07081'
ti_startup - product 0000, num configurations 0, configuration value 0
olecom@flower:/tmp$ sh -c '. ./bb ; _07082'
not reached
olecom@flower:/tmp$
olecom@flower:/tmp$ sh -c '. ./bb ; _07081 777 7 8'
ti_startup - product 0x0309, num configurations 7, configuration value 8
olecom@flower:/tmp$

_(banana.c and banana.sh can be found in the ftp /upload on my server)_

>From file linux/drivers/usb/serial/ti_usb*c with

[...]
        dbg("%s - product 0x%4X, num configurations %d, configuration value %d",
            __FUNCTION__, le16_to_cpu(dev->descriptor.idProduct),
            dev->descriptor.bNumConfigurations,
            dev->actconfig->desc.bConfigurationValue);
[...]


lets tacke one particular function (transformed a little bit):
_*_

#include <stdio.h>

#define dbg printf
#define ti_startup(foo)				main (int argc, char **argv)
#define dev_descriptor_idProduct		3
#define dev_descriptor_bNumConfigurations	4
#define dev_actconfig_desc_bConfigurationValue	5

/* declaration */
int ti_startup(void);

/* implementation */
int ti_startup(void)
{
	dbg("start\n");

	return dbg("%s - product %#.4x, num configurations %d, "
			"configuration value %d\n",
	__FUNCTION__, dev_descriptor_idProduct,
	dev_descriptor_bNumConfigurations,
	dev_actconfig_desc_bConfigurationValue);

	/* bla bla */
	dbg("not reached\n");
}
_*_

* Process this file with this script: *

_*_

# just as an example
USB_SERIAL_ID=07
TI_USB_ID=08
__FILE__="ti_usb_3410_5052.c" # possible
i=0

sed -n '
# finding function body
/^[[:alpha:]]/{
	# found, print it for __FUNCTION__ keyword
	s_[^ ]* *\([^ (]*\).*[^;]$_\1_p;
	t_func ; b ;
	# walking inside of a function
	:_func;
	# load next string from the input
	n;
	# while not the end of a function
	/^}/{
		# insert delimiter, i.e \n\n is the end of a function
		s_.*_\n_p;
		# go out
		b;
	};
	# find "dbg" (or printk, whatever) inside
	/dbg *(/{
		:_dbg;
		# while not the end of argumet list, i.e ";\n", add other line
		/;$/!{N ; b_dbg}
		# change C to sh
		s_dbg *(_@printf _;
		# clear beginnig of the string
		s_^[^@]*@__;

		# if there is a __FUNCTION__ or __func__ keyword
		/__[Ff]/{
			# NOTE: then first %s in format is replaced with $FUNC
			s_%s_$FUNC_
		}

		# strip "\n\tabs"
		s_\n[[:blank:]]*__g;
		# clear the end, i.e |..."format"/,.*//| or |.."format"/).*//|
		s_"[,)].*_"_;
		# print result
		p;
	}
	b_func;
}'| while read FUNC
do
    printf "_$USB_SERIAL_ID$TI_USB_ID(){
FUNC=$FUNC
}
"
    FUNC=_$USB_SERIAL_ID$TI_USB_ID
    while read -r PRINT
       do test "$PRINT" && printf "$FUNC$i() {
$FUNC
%s "'"$@"'"
}
" "$PRINT"
	  i=$(($i+1))
     done
done
_*_

Now switch on imagination and see how printk just puts
'\007\010\params'

and userspace after some banana `od`dity just calls shell functions.

Yet another thing to export to the userspace. But surely only for those
who whats that.
--
-o--=O`C
 #oo'L O
<___=E M
