Return-Path: <linux-kernel-owner+w=401wt.eu-S1757694AbXFQAom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbXFQAom (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 20:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758074AbXFQAo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 20:44:28 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2654 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757986AbXFQAo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 20:44:26 -0400
Message-ID: <467483F5.8020706@shadowen.org>
Date: Sun, 17 Jun 2007 01:44:37 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.05
References: <c0970fee9a3802d4930b2a9ac96fdd57@pinky> <Pine.LNX.4.64.0706162353390.32724@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706162353390.32724@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jun 16 2007 22:42, Andy Whitcroft wrote:
>> @@ -180,12 +182,17 @@ sub ctx_block_get {
>> sub ctx_block_outer {
>> 	my ($linenr, $remain) = @_;
>>
>> -	return ctx_block_get($linenr, $remain, 1);
>> +	return ctx_block_get($linenr, $remain, 1, '\{', '\}');
> 
> '\\{'.

I want the string to be \{ ... '\}' gives me that:

$ perl
$q = '\}';
print "$q\n";
\}

> Or, if it works, directly use
> 	return &ctx_block_get($linenr, $remain, 1, qr/\{/, qr/\}/);
> 
>> +sub ctx_statement {
>> +	my ($linenr, $remain) = @_;
>> +
>> +	return ctx_block_get($linenr, $remain, 0, '\(', '\)');
> 
> ^^
> 
>> +	my $ident	= '[A-Za-z\d_]+';
> 
> Oh yes, use the qr operator here. (qr{}, qr//, choose anything like you
> would do with m//)

Well I want a combination of variable expanded and not expanded.  I
think there will be a general cleanup to some standard quoting for the
RE's as there are hundreds, and about 7 different quote styles right now.

> 
>> +	my $storage	= '(?:extern|static)';
>> +	my $sparse	= '(?:__user|__kernel|__force|__iomem)';
>> +	my $type	= '(?:unsigned\s+)?' .
>> +			  '(?:void|char|short|int|long|unsigned|float|double|' .
>> +			  'long\s+long|' .
>> +			  "struct\\s+${ident}|" .
>> +			  "union\\s+${ident}|" .
>> +			  "${ident}_t)" .
>> +			  "(?:\\s+$sparse)*" .
>> +			  '(?:\s*\*+)?';
>> +	my $attribute	= '(?:__read_mostly|__init|__initdata)';
>> +
>> +	my $Ident	= $ident;
>> +	my $Type	= $type;
>> +	my $Storage	= $storage;
>> +	my $Declare	= "(?:$storage\\s+)?$type";
>> +	my $Attribute	= $attribute;
>> +
> 
>> #trailing whitespace
>> -		if ($line=~/\+.*\S\s+$/) {
>> +		if ($line=~/^\+.*\S\s+$/) {
>                 if ($line =~ /^\+.*\S\s+$/) {
>> 			my $herevet = "$here\n" . cat_vet($line) . "\n\n";
>> 			print "trailing whitespace\n";
>> 			print "$herevet";
>> @@ -392,17 +420,20 @@ sub process {
>> 		#
>> 		next if ($in_comment);
>>
>> -		# Remove comments from the line before processing.
>> +# Remove comments from the line before processing.
>> 		$line =~ s@/\*.*\*/@@g;
>> 		$line =~ s@/\*.*@@;
> 
> C being a wonderful language, has this nice pitfall for parsers
> 
> 	foo = number /*pointer_to_int;

Hmm really?  Thats not how gcc seems to parse that, it seems to think
its a comment.  Which makes us safe, as the compiler will trip them up.

$ cat test4.c
int main(int argc, char *argv[])
{
        int _p = 10;
        int *p = &_p;

        int foo = 10 /*p;

        printf("foo=%d\n", foo);
}
$ cc -o test4 test4.c
test4.c:6:15: error: unterminated comment
test4.c: In function 'main':
test4.c:6: error: expected ',' or ';' at end of input
test4.c:6: error: expected declaration or statement at end of input

>> 		$line =~ s@.*\*/@@;
>>
>> -		#
>> -		# Checks which may be anchored in the context.
>> -		#
>> +# Standardise the strings and chars within the input to simplify matching.
>> +		$line = sanitise_line($line);
>> +
>> +#
>> +# Checks which may be anchored in the context.
>> +#
>>
>> -		# Check for switch () and associated case and default
>> -		# statements should be at the same indent.
>> +# Check for switch () and associated case and default
>> +# statements should be at the same indent.
>> 		if ($line=~/\bswitch\s*\(.*\)/) {
> 
> Codingstyle warrants \bswitch\s+  :)

Yep and we check for that.  But here we are trying to catch a switch and
case at differing levels, we want to catch that whether they got their
spacing right or not.

>> # * goes on variable not on type
>> -		my $type = '(?:char|short|int|long|unsigned|float|double|' .
>> -			   'struct\s+[A-Za-z\d_]+|' .
>> -			   'union\s+[A-Za-z\d_]+)';
>> -
> 
> qr. (I don't know what it is good for - compare qr/xyz/ with 'xyz'...,
> but there's a reason to its existence, so let's use it :-)

Well I would tend to say use what works and is easy to understand.  The
semantics of '' and "" are well known, to change to qr{} I would have to
go read the manual to know what it is going to do.  That said, _if_ it
did have the same semantics as m// then it may wel allow all of these to
be expressed as qr{} as it would expand variables but treat \ as if we
were in ''.  So ... to the manual for me.

-apw
