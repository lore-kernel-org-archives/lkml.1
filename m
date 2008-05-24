Return-Path: <linux-kernel-owner+w=401wt.eu-S1759906AbYEXPst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906AbYEXPst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756687AbYEXPsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:48:41 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:42121 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbYEXPsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:48:39 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: kernel-janitors@vger.kernel.org
Subject: some numbers on macros
Date: Sat, 24 May 2008 17:48:19 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_DjDOIyr5A7ojsRE"
Message-Id: <200805241748.19607.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_DjDOIyr5A7ojsRE
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

	I wrote a rather dumb script to see some numbers on macros I was
interested in. The script basically parses *.c file, finds macro definitions
and counts how many times each macro was used in this source file. The script
doesn't see any context so it can produce false positives - that is one of
the reasons it doesn't look into header files - it's simply too dumb.

The macros I was interested in were these which are:
- defined and unused
- defined and used only once
- defined more than once

I dont want to start another cleanup-patches-storm so first I'd like to
know if this excersise is worth it as unused macros do not do much harm.

Would such patches be accepted?

	Mariusz



example on recent linux-2.6 snapshot:

$ ./find_interesting_macros.php linux-2.6
[snip]
10189 files to parse

used  defined   macro
[snip]
0       1       'Tracev'                        /home/mariusz/linux/linux-2.6/init/initramfs.c +400
0       1       'Tracevv'                       /home/mariusz/linux/linux-2.6/init/initramfs.c +401
0       1       'Tracec'                        /home/mariusz/linux/linux-2.6/init/initramfs.c +402
0       1       'Tracecv'                       /home/mariusz/linux/linux-2.6/init/initramfs.c +403
1       1       'version_string'                /home/mariusz/linux/linux-2.6/init/version.c +17
8       2       'DBG'                           /home/mariusz/linux/linux-2.6/sound/soc/at91/at91-ssc.c +39
4       2       'DBG'                           /home/mariusz/linux/linux-2.6/sound/soc/at91/at91-pcm.c +37
8       2       'DBG'                           /home/mariusz/linux/linux-2.6/sound/soc/at91/eti_b1_wm8731.c +44
25      2       'DBG'                           /home/mariusz/linux/linux-2.6/sound/soc/s3c24xx/s3c2412-i2s.c +49
21      2       'DBG'                           /home/mariusz/linux/linux-2.6/sound/soc/s3c24xx/s3c24xx-i2s.c +49
19      2       'DBG'                           /home/mariusz/linux/linux-2.6/sound/soc/s3c24xx/s3c24xx-pcm.c +42
0       2       'dbg'                           /home/mariusz/linux/linux-2.6/sound/soc/codecs/wm8750.c +41
1       1       'info'                          /home/mariusz/linux/linux-2.6/sound/soc/codecs/wm8750.c +48
0       1       'warn'                          /home/mariusz/linux/linux-2.6/sound/soc/codecs/wm8750.c +50
1       1       'wm8750_reset'                  /home/mariusz/linux/linux-2.6/sound/soc/codecs/wm8750.c +120
0       2       'dbg'                           /home/mariusz/linux/linux-2.6/sound/soc/codecs/wm8731.c +41
1       1       'info'                          /home/mariusz/linux/linux-2.6/sound/soc/codecs/wm8731.c +48
0       1       'warn'                          /home/mariusz/linux/linux-2.6/sound/soc/codecs/wm8731.c +50
1       1       'wm8731_reset'                  /home/mariusz/linux/linux-2.6/sound/soc/codecs/wm8731.c +120
...

BTW. How many unused macros are in *.c files?

$ ./find_interesting_macros.php linux-2.6 | grep "^0" | wc -l
1340

Well ... since it produces some false positives the real number can differ a little.
This is an example of a macro that will cause false positive:

scripts/kconfig/kconfig_load.c +7
#define P(name,type,arg)        type (*name ## _p) arg
#include "lkc_proto.h"
#undef P


--Boundary-00=_DjDOIyr5A7ojsRE
Content-Type: application/x-php;
  name="find_interesting_macros.php"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="find_interesting_macros.php"

#!/usr/bin/php
<?
	$src = $_SERVER["argv"][1];
	if ($src == "")
		die("you need to specify source directory as a first argument\n");

	$tree = array();

	get_files($src);

	echo "this script looks at macros within single *.c file scope\n";
	echo "it is rather dumb and it CAN produce false-positives\n";
	echo "as it doesn't see any context - feel free to improve it\n";
	echo "used - how many times a macro was used in given file\n";
	echo "defined - how many times #define foo() was found in given file\n";
	echo "\n";
	echo count($tree)." files to parse\n\n";
	echo "used  defined\tmacro\n";

	foreach ($tree as $file)
		parse_file($file);

	function get_files($path)
	{
		global $tree;

		$dir = opendir($path);
		if ($dir === false)
			return;

		while ($file = readdir($dir)) {
			if ($file[0] == '.')
				continue;

			$tmp = $path;
			if ($tmp[strlen($tmp) - 1] != '/')
				$tmp .= "/";

			$tmp .= $file;

			if (is_dir($tmp))
				get_files($tmp);
			else if (preg_match("/\.c$/", $tmp))
				$tree[] = $tmp;
		}

		closedir($dir);
	}

	/*
	 * Tokens statistics are per file here. Thus it is possible that the macro used
	 * in wider context will be shown here as unused etc. Hence we parse only *.c files
	 * as those are rarely included into other *.c files.
	 */
	function parse_file($path)
	{	
		$line_nr = 0;
		$comment = false;

		$token = array();
		$tc = 0;

		$cache = array();
		$cc = 0;

		$file = fopen($path, "r");
		if (!$file)
			return;

		while (!feof($file)) {
			$line = fgets($file, 256);
			$line_nr++;

			if (preg_match("/\/\*/", $line))
				$comment = true;

			if ($comment && strstr($line, "*/"))
				$comment = false;

			if ($comment)
				continue;

			if (!preg_match("/^#define/", $line)) {
				if (preg_match("/^#/", $line))
					continue; /* not interested in other cpp stuff */

				if (strlen($line) > 5) {
					/* this line we should cache */
					$cache[$cc] = $line;
					$cc++;
				}

				continue;
			}

			/* the line starts with #define so lets find the token now */
			$a = 7;
			$b;

			for (; $a < strlen($line); $a++)
				if (in_array(ord($line[$a]), array(32, 9)))
					break;
			$a++;

			for ($b = $a; $b < strlen($line); $b++)
				if (in_array(ord($line[$b]), array(32, 9, 40)))
					break;
			if (ord($line[$b]) != 40)
				continue;
			$b -= $a;

			$text = substr($line, $a, $b);
			if (!strlen($text))
				continue;

			/* update stats in case macro was defined twice or more */
			for ($i = 0; $i < $tc; $i++)
				if ($token[$i]['text'] == $text) {
					$token[$i]['defined']++;
					break;
				}

			if ($i != $tc)
				continue; /* token already known */
					
			/* add new token to known tokens */
			$token[$i]['text'] = $text;
			$token[$i]['line'] = $line;
			$token[$i]['path'] = $path;
			$token[$i]['line'] = $line_nr;
			$token[$i]['used'] = 0;
			$token[$i]['defined'] = 1;
			$tc++;
		}

		fclose($file);

		for ($i = 0; $i < $tc; $i++) {
			for ($j = 0; $j < $cc; $j++)
				if (strstr($cache[$j], $token[$i]['text']))
					 $token[$i]['used']++;

			/*
			 * Interesting tokens arer these which are:
			 * - defined but unused
			 * - defined and used once
			 * - defined more than once
			 */
			if ($token[$i]['used'] > 1 && $token[$i]['defined'] == 1)
				continue;

			echo $token[$i]['used']."\t".$token[$i]['defined']."\t'";

			/* make the output pretty :) */
			echo chr(0x1b).chr(0x5b);
			switch ($token[$i]['used']) {
			case 0:
				echo "31m";
				break;
			case 1:
				echo "33m";
				break;
			default:
				echo "32m";
			}

			echo $token[$i]['text'].chr(0x1b).chr(0x5b)."m'\t";

			$len = strlen($token[$i]['text']);
			if ($len < 6)
				echo "\t";
			if ($len < 14)
				echo "\t";
			if ($len < 22)
				echo "\t";

			/*
			 * the '+' makes vim go to the line where macro was defined
			 * $ vim /some/path/to/some/file.c +1234
			 */
			echo $token[$i]['path']." +".$token[$i]['line']."\n";
		}
	}
?>

--Boundary-00=_DjDOIyr5A7ojsRE--
