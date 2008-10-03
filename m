Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbYJCX5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbYJCX5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 19:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYJCX5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 19:57:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:57791 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbYJCX5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 19:57:13 -0400
Date: Fri, 3 Oct 2008 16:57:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] cstate ftrace userland script
Message-ID: <20081003165705.17d7ad3c@infradead.org>
In-Reply-To: <20081003165533.249261b1@infradead.org>
References: <20081003165533.249261b1@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and here's a script to turn the cstate ftrace output into a nice SVG
that you can view with inkscape

#!/usr/bin/perl

# Copyright 2008, Intel Corporation
#
# This file is part of the Linux kernel
#
# This program file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program in a file named COPYING; if not, write to the
# Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor,
# Boston, MA 02110-1301 USA
#
# Authors:
# 	Arjan van de Ven <arjan@linux.intel.com>


#
# This script turns a cstate ftrace output into a SVG graphic that shows 
# historic C-state information
#
#
# 	cat /sys/kernel/debug/tracer/trace | perl cstate.pl > out.svg
#

my @rows;
my @styles;
my $base = 0;


$styles[0] = "fill:rgb(0,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
$styles[1] = "fill:rgb(0,255,0);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
$styles[2] = "fill:rgb(255,0,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
$styles[3] = "fill:rgb(255,255,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
$styles[4] = "fill:rgb(255,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
$styles[5] = "fill:rgb(0,255,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
$styles[6] = "fill:rgb(0,128,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
$styles[7] = "fill:rgb(0,255,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
$styles[8] = "fill:rgb(255,0,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
my $stylecounter = 0;


print "<?xml version=\"1.0\" standalone=\"no\"?> \n";
print "<svg width=\"10000\" height=\"100%\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n";

my $scale = 30000.0;
while (<>) {
	my $line = $_;
	if ($line =~ /([0-9\.]+)\] Going to C([0-9]) on cpu ([0-9]+) for ([0-9\.]+)/) {
#	if ($line =~ /([0-9\.]+)\] Going to C([0-9]) /) {
		if ($base == 0) {
			$base = $1;
		}
		my $time = $1 - $base;	
		my $time = $time * $scale;
		my $C = $2;
		my $cpu = $3;
		my $y = 200 * $cpu;
		my $duration = $4 * $scale;
		my $msec = int($4 * 100000)/100.0;
		my $height = $C * 20;
		$style = $styles[$C];
		
		$y = $y + 140 - $height;
		
		$x2 = $time + 4;
		$y2 = $y + 4;


		print "<rect x=\"$time\" width=\"$duration\" y=\"$y\" height=\"$height\" style=\"$style\"/>\n";
		print "<text transform=\"translate($x2,$y2) rotate(90)\">C$C $msec</text>\n";
	}
}


print "</svg>\n";


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
