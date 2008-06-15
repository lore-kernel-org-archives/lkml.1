Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbYFOPy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbYFOPy4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 11:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758246AbYFOPyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 11:54:45 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:47013 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227AbYFOPyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 11:54:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GWZ2KfsUZ5j/bTrOionqP1kwbnq6nq+2MygX83qQWYdnKhgO/vdG4tLgF3lwPOACJe
         iCDe4gttPz6fhQVo87fNWpTRU9fnEPPb3i4YeAlTTawgYl8Vy/++MvD6PVwLGdZr6yzk
         BkTaeDXjGdy3nHVjqtDL/YbnACgn3Uc6fbzYw=
Message-ID: <48553B3C.6090806@gmail.com>
Date: Sun, 15 Jun 2008 17:54:36 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       balbir@linux.vnet.ibm.com, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       yamamoto@valinux.co.jp, menage@google.com, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com, linux-arch@vger.kernel.org
Subject: Re: [PATCH -mm] PAGE_ALIGN(): correctly handle 64-bit values on 32-bit
 architectures (v2)
References: <> <1213543436-15254-1-git-send-email-righi.andrea@gmail.com>
In-Reply-To: <1213543436-15254-1-git-send-email-righi.andrea@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> Also move the PAGE_ALIGN() definitions out of include/asm-*/page.h in
> include/linux/mm.h.
> 
> See also lkml discussion: http://lkml.org/lkml/2008/6/11/237
> 
> ChangeLog: v1 -> v2
>  - fix some PAGE_ALIGN() undefined references due to the move of PAGE_ALIGN
>    definition in linux/mm.h

BTW, I've used the following script to discover the missing inclusions
of <linux/mm.h> in files of the different archs that use PAGE_ALIGN().

I don't know if there's a better way to check this (well... obviously
except recompiling everything on all the architectures).

I'm posting the script here, maybe it could be useful also for other
similar stuff.

It just greps the direct and indirect .h inclusions (up to a maximum
level of 5 indirect inclusions, by default) in .c files and if it doesn't
find the required #include (linux/mm.h in this case), it reports an
error.

It does not cover #ifdefs and different CONFIGs, but it would be able at
least to reduce potential build errors due to undefined references (of
PAGE_ALIGN in this case). If there're no evident bugs the script should
be able to provide a sufficient condition for correctness.

A downloadable version of the script is also available here:
http://download.systemimager.org/~arighi/linux/scripts/check-include.pl

For example to check if the files that use PAGE_ALIGN() include
<linux/mm.h> on ia64 arch (without recompiling everything):

$ time check-include.pl --arch ia64 --include linux/mm.h \
`git-grep -l [^_]PAGE_ALIGN arch/ia64` \
`git-grep -l [^_]PAGE_ALIGN | grep -v '^arch\|^include\|\.h$'`
...

and on a intel core2 duo 1.2GHz it needs only:
real    0m5.229s
user    0m4.536s
sys     0m0.664s

-Andrea
---
#!/usr/bin/perl -w
#
#  check-include.pl
#
#  Description:
#    Check if one or more C files (.c) in a Linux kernel tree directly or
#    indirectly include a C header (.h).
#
#  Copyright (C) 2008 Andrea Righi <righi.andrea@gmail.com>

use strict;
use File::Basename;
use Getopt::Long;

my $VERSION = '0.1';
my $program_name = 'check-include.pl';

my $version_info = << "EOF";
$program_name v$VERSION

Copyright (C) 2008 Andrea Righi <righi.andrea\@gmail.com>

This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
EOF

my $help_info = $version_info . <<"EOF";

Usage: $program_name --include INCLUDE --arch ARCH [OPTION]... FILE...

Options:
 --help, -h             Display this output.

 --version, -v          Display version and copyright information.

 --include, -i=INCLUDE  Search INCLUDE inclusion, as specified in #include
			(i.e. linux/mm.h).

 --arch, -a=ARCH	Use assembly inclusions of the specified ARCH, the
			name of the arch must be the same as specified in
			include/asm-* (i.e. x86).

 --level, -l=NUM	Expand header inclusions up to NUM nested levels.
			Beyond this limit we consider the inclusion missing.
			Default max level is: 5.
EOF

select(STDERR);
$| = 1;
select(STDOUT);
$| = 1;

Getopt::Long::Configure("posix_default");
Getopt::Long::Configure("no_gnu_compat");
Getopt::Long::Configure("bundling");
GetOptions(
	"help|h"	=> \my $help,
	"version|v"	=> \my $version,
	"include|i=s"	=> \my $include,
	"arch|a=s"	=> \my $arch,
	"level|l=i"	=> \my $level,
) or die("$help_info");

if ($help) {
	print "$help_info";
	exit(0);
}
if ($version) {
	print "$version_info";
	exit(0);
}
unless ($include) {
	print STDERR "ERROR: --include option is mandatory\n";
	print "\n$help_info";
	exit(1);
}
unless ($arch) {
	print STDERR "ERROR: --arch option is mandatory\n";
	print "\n$help_info";
	exit(1);
}
unless ($level) {
	$level = 5;
}

# try to evaluate if we're in a Linux kernel tree
# TODO: there're surely better ways to do so...
unless ((-f 'README') && (-f 'MAINTAINERS')) {
	die("fatal: not a Linux kernel tree\n");
}

my @files = sort_unique(@ARGV);
unless (@files) {
	print "no file specified\n";
	exit(0);
}

my $ret = 0;
my $cache;
foreach my $file (@files) {
	if ($file !~ /\.c$/) {
		print STDERR "$file: is not a C file\n";
		next;
	}
	if (! -f $file) {
		print STDERR "$file: does not exist\n";
		next;
	}
	print "checking $file : ";
	my $found = 0;
	for (my $i = 1; $i <= $level; $i++) {
		my @includes = get_includes($arch, $i, $include, $file);
		$_ = resolve_std_inc($arch, $include);
		if (grep(/^include\/$_$/, @includes) ||
		    !check_include($include, @includes)) {
			$found = 1;
			last;
		}
	}
	if ($found) {
		print "ok\n";
		next;
	}
	$ret = 1;
	print "$include was not found!\n";
}
exit($ret);

sub sort_unique
{
	my @in = @_;
	my %saw;
	@saw{@_} = ();
	return sort keys %saw;
}

sub resolve_std_inc {
	my $arch = shift;
	$_ = shift;
	s/include\/asm\//include\/asm-$arch\//;
	return $_;
}

sub resolve_loc_inc {
	my $file = shift;
	$_ = shift;
	return dirname($file) . "/$_";
}

sub get_includes {
	my ($arch, $level, $include, $file) = @_;
	my @includes = ();

	if ($cache->{$file}->{$level}) {
		goto out;
	}
	@_ = ($file);
	for (my $i = 1; $i <= $level; $i++) {
		if ($cache->{$file}->{$i}) {
			@_ = @{$cache->{$file}->{$i}};
			push(@includes, @_);
			next;
		}
		my @list = @_;
		@_ = ();
		foreach my $e (@list) {
			my $res = open(IN, "<$e");
			next unless($res);
			chomp(my @in = <IN>);
			close(IN);

			my @inc = grep(s/#include\s+<([^>]+)>.*/include\/$1/,
				       @in);
			if (@inc) {
				# Resolve assembly inclusions.
				map { $_ = resolve_std_inc($arch, $_) } @inc;
				push(@_, @inc);
			}

			@inc = grep(s/#include\s+"([^>]+)".*/$1/,
				       @in);
			if (@inc) {
				# Resolve local inclusions.
				map { $_ = resolve_loc_inc($e, $_) } @inc;
			        push(@_, @inc);
			}
		}
		last unless (@_);
		push(@includes, @_);
	}
	@{$cache->{$file}->{$level}} = sort_unique(@includes);
out:
	return @{$cache->{$file}->{$level}};
}

sub check_include {
	my ($include, @files) = @_;

	foreach (@files) {
		my $res = open(IN, "<$_");
		next unless ($res);
		chomp(my @in = <IN>);
		close(IN);
		return 0 if (grep(/#include\s+<$include>/, @in))
	}
	return -1;
}

__END__
